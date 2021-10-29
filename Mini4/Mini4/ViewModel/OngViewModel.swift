//
//  OngViewModel.swift
//  Mini4
//
//  Created by Gustavo Rigor on 28/09/21.
//
import Combine
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage


class OngViewModel : ObservableObject {
    @Published var data = [Organizacao]()
    
    private let ongService: OngServiceProtocol
        
    //for reading purpose it will automatically add data when we write data to firestore.
    private let dbOng = Firestore.firestore().collection("ong")
    
    init(ongService: OngServiceProtocol = OngService()) {
        self.ongService = ongService
        dbOng.addSnapshotListener({ (snap_, err) in
            guard let snap = snap_ else {return}
            
            if let erro = err {
                print(erro.localizedDescription)
                return
            }
            
            for i in snap.documentChanges{
                if i.type == .added{
                    
                    var msgData = Organizacao(
                        id: i.document.documentID,
                        nome: self.castString(i.document.get("nome")),
                        cnpj: self.castString(i.document.get("cnpj")),
                        descricao: self.castString(i.document.get("descricao")),
                        telefone: self.castString(i.document.get("telefone")),
                        email: self.castString(i.document.get("email")),
                        foto: self.castString(i.document.get("foto")),
                        data: Timestamp.init(date: Date()),
                        banco: Banco(banco: "31231", agencia: "", conta: "", pix: ""),
                        endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: "")
                    )
                    
                    let group = DispatchGroup()
                    
                    group.enter()
                    
                    self.dbOng.document(msgData.id!).collection("banco").getDocuments { endData, err in
                        guard let endData = endData else { return }

                        for j in endData.documentChanges {

                            let bancoData = j.document.data()
                            let nome = self.castString(bancoData["banco"])
                            let agencia = self.castString(bancoData["agencia"])
                            let pix = self.castString(bancoData["pix"])
                            let conta = self.castString(bancoData["conta"])
                            let banco = Banco(id: self.castString(bancoData["id"]), banco: nome, agencia: agencia, conta: conta, pix: pix)
                            
                            msgData.banco = banco
                            print("MSG: \(msgData.banco.banco)")
                        }
                        
                        group.leave()
                    }
                    
                    group.enter()
                    
                    self.dbOng.document(msgData.id!).collection("endereco").getDocuments { endData, err in
                        guard let endData = endData else { return }

                        for j in endData.documentChanges {

                            let enderecoData = j.document.data()

                            let cidade = self.castString(enderecoData["cidade"])
                            let logradouro = self.castString(enderecoData["logradouro"])
                            let numero = self.castString(enderecoData["numero"])
                            let estado = self.castString(enderecoData["estado"])
                            let cep = self.castString(enderecoData["cep"])
                            let bairro = self.castString(enderecoData["bairro"])
                            let id = self.castString(enderecoData["id"])
                            
                            let endereco = Endereco(id: id, logradouro: logradouro, numero: numero, bairro: bairro, cidade: cidade, cep: cep, estado: estado)
                            
                            msgData.endereco = endereco
                        }
                        
                        group.leave()
                    }
                                                            
                    group.notify(queue: .main) {
                        self.data.append(msgData)
                    }
                }
                if i.type == .modified{
                    for j in 0..<self.data.count{
                        if self.data[j].id == i.document.documentID{
                            self.data[j].cnpj = self.castString(i.document.get("cnpj"))
                            self.data[j].nome = self.castString(i.document.get("nome"))
                            //self.data[j].data = self.castTimestamp(i.document.get("data"))
                            self.data[j].descricao = self.castString(i.document.get("descricao"))
                            self.data[j].telefone = self.castString(i.document.get("telefone"))
                            if self.data[j].foto != nil {
                                self.data[j].foto = self.castString(i.document.get("foto"))
                            }
                        }
                    }
                }
                if i.type == .removed{
                    self.data.remove(at: self.data.firstIndex(where: { ong in
                        i.document.documentID == ong.id
                    })!)
                }
            }
            
            
        })
    }
    
    func castString(_ variable: Any?) -> String{
        if let str = variable as? String{
            return str
        }
        return ""
    }
    
    func castTimestamp(_ variable: Any?) -> Timestamp{
        if let timestamp = variable as? Timestamp{
            return timestamp
        }
        return Timestamp(date: Date())
    }
    
    private func createOrg(id: String, ong: Organizacao) -> AnyPublisher<Void, Error>{
        return ongService.create(ong).eraseToAnyPublisher()
    }
    
    func addOrgData(org: Organizacao, image: UIImage?){
        let ong1 = dbOng.document(org.id!)
        let banco = dbOng.document(ong1.documentID).collection("banco").document("principal")
        let endereco = dbOng.document(ong1.documentID).collection("endereco").document("principal")
        let estoque = dbOng.document(ong1.documentID).collection("estoque").document("item0")
                
        var ongData = ["id": org.id!,
                       "cnpj": org.cnpj,
                       "nome": org.nome,
                       "descricao": org.descricao,
                       "telefone": org.telefone,
                       "email": org.email,
                       "data": Timestamp(date: Date())]
            as [String : Any]
        
        
        if let image = image {
            
            ImageStorageService.shared.uploadImage(orgName: org.nome, image: image) { urlString, err in
                ongData["foto"] = urlString
                
                ong1.setData(ongData) { (err) in
                    if let erro = err?.localizedDescription {
                        print(erro)
                        return
                    }
                }
            }
        }

        ong1.setData(ongData) { (err) in
            if let erro = err?.localizedDescription {
                print(erro)
                return
            }
        }

        banco.setData([
            "id": banco.documentID,
            "banco": org.banco.banco,
            "agencia": org.banco.agencia,
            "conta": org.banco.conta,
            "pix": org.banco.pix
        ]) { (err) in
            if let erro = err?.localizedDescription {
                print(erro)
                return
            }
        }
        
        endereco.setData([
            "id": endereco.documentID,
            "logradouro": org.endereco.logradouro,
            "numero": org.endereco.numero,
            "bairro": org.endereco.bairro,
            "cidade": org.endereco.cidade,
            "cep": org.endereco.cep,
            "estado": org.endereco.estado
        ]) { (err) in
            if let erro = err?.localizedDescription {
                print(erro)
                return
            }
        }
        
        estoque.setData([
            "id": estoque.documentID,
            "nome": "...",
            "quantidade": 1,
            "urgente": false,
            "visivel": true
        ]) { (err) in
            if let erro = err?.localizedDescription {
                print(erro)
                return
            }
        }
    }
    
    func updateOng(ong: Organizacao, image: UIImage?) {
        var ongData = ["cnpj": ong.cnpj,
                       "nome": ong.nome,
                       "descricao": ong.descricao,
                       "telefone": ong.telefone,
                       "email": ong.email,
                       "data": Timestamp(date: Date())]
            as [String : Any]
        
        
        if let image = image {
            
            ImageStorageService.shared.uploadImage(orgName: ong.nome, image: image) { urlString, error in
                
                ongData["foto"] = urlString
                
                self.dbOng.document(ong.id!).updateData(ongData) { (err) in
                    if err != nil{
                        print((err?.localizedDescription)!)
                        return
                    }
                    print("success com foto")
                }
                
            }
        }
        
        self.dbOng.document(ong.id!).updateData(ongData){ (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            print("success sem foto")
        }
    }
    
    func deleteOng(ong: Organizacao){
        if let id = ong.id{
            dbOng.document(id).delete{ erro in
                if let err = erro {
                    print(err.localizedDescription)
                    return
                }
            }
        }
    }

    func gerarNovaOng() -> Organizacao {
        return Organizacao(
            nome: "", cnpj: "", descricao: "", telefone: "", email: "", data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
            endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
    }
    
    func getOng(id: String) -> Organizacao {
        print("id getOng \(id)")
                
        let ong = self.data.first(where: { $0.id == id} )
        return ong ?? Organizacao(
            nome: "n tem ong", cnpj: "", descricao: "", telefone: "", email: "", data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
            endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
    }
    
    private func idAtual() -> AnyPublisher<String, Error>{
        return Just("").setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func mockOngMariaHelena() -> Organizacao {
        let ong = Organizacao(nome: "Casa Maria Helena Paulina",
                              cnpj: "69.107.142/0001-59",
                              descricao: "A Casa Maria Helena Paulina é uma organização não governamental paulista fundada em 1992 que acolhe jovens com câncer - ou outras enfermidades - e seus acompanhantes oriundos de diversos estados brasileiros que encaminham-se para São Paulo em busca de infraestrutura de tratamento adequado às suas necessidades. A Casa fornece moradia, alimentos, assistência psicológica, produtos de higiene e as mais variadas atividades para que a estadia dos assistidos seja a melhor possível apesar de todas as dificuldades encontradas ao longo do tratamento.",
                              telefone: "(11) 3744-7492",
                              email: "contato@casamariahelenapaulina.org.br",
                              foto: "",
                              data: Timestamp(date: Date()),
                              banco: Banco(banco: "Banco Itaú",
                                           agencia: "0062",
                                           conta: "35.926-0",
                                           pix: "69.107.142/0001-59"),
                              endereco: Endereco(logradouro: "R. Judith Passald Esteves",
                                                 numero: "137",
                                                 bairro: "Jd. Colombo",
                                                 cidade: "São Paulo",
                                                 cep: "05625-030",
                                                 estado: "SP"))
        return ong
    }
}

