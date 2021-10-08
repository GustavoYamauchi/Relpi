//
//  OngViewModel.swift
//  Mini4
//
//  Created by Gustavo Rigor on 28/09/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore


class OngViewModel : ObservableObject {
    @Published var data = [Organizacao]()
    
    //for reading purpose it will automatically add data when we write data to firestore.
    private let dbOng = Firestore.firestore().collection("ong")
    
    init() {
        
        dbOng.addSnapshotListener({ (snap_, err) in
            guard let snap = snap_ else {return}
            
            if let erro = err {
                print(erro.localizedDescription)
                return
            }
            
            for i in snap.documentChanges{
                if i.type == .added{
                    let msgData = Organizacao(
                        id: i.document.documentID,
                        nome: self.castString(i.document.get("nome")),
                        cnpj: self.castString(i.document.get("cnpj")),
                        descricao: self.castString(i.document.get("descricao")),
                        telefone: self.castString(i.document.get("telefone")),
                        email: self.castString(i.document.get("email")),
                        foto: self.castString(i.document.get("foto")),
                        data: Timestamp.init(date: Date()),
                        banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
                        endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: "")
                    )
                    self.data.append(msgData)
                }
                if i.type == .modified{
                    for j in 0..<self.data.count{
                        if self.data[j].id == i.document.documentID{
                            self.data[j].cnpj = self.castString(i.document.get("cnpj"))
                            self.data[j].nome = self.castString(i.document.get("nome"))
                            self.data[j].data = self.castTimestamp(i.document.get("data"))
                            self.data[j].descricao = self.castString(i.document.get("descricao"))
                            self.data[j].telefone = self.castString(i.document.get("telefone"))
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
    
    func addOrgData(org: Organizacao){
        let ong1 = dbOng.document()
        let banco = dbOng.document(ong1.documentID).collection("banco").document("principal")
        let endereco = dbOng.document(ong1.documentID).collection("endereco").document("principal")
        let estoque = dbOng.document(ong1.documentID).collection("estoque").document("item0")
        
        ong1.setData([
            "id" : ong1.documentID,
            "nome": org.nome,
            "cnpj": org.cnpj,
            "descricao": org.descricao,
            "telefone": org.telefone,
            "data": Timestamp(date: Date()),
            "email": org.email
        ]) { (err) in
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
    
    func updateOng(ong: Organizacao) {
        dbOng.document(ong.id!).updateData(
            ["cnpj": ong.cnpj,
             "nome": ong.nome,
             "descricao": ong.descricao,
             "telefone": ong.telefone,
             "email": ong.email,
             "data": Timestamp(date: Date()),
            ]
        ){ (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            print("success")
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
    
    func imageToString(image: UIImage) -> String {
        if let imageData = image.pngData() {
            let stringData = imageData.base64EncodedString()
            return stringData
        }
        return ""
    }
    
    func stringToImage(ong: Organizacao) -> UIImage? {
        if ong.foto != "" && ong.foto != Optional("") && ong.foto != nil {
            let decodedData = Data(base64Encoded: ong.foto!, options: [])
            if let data = decodedData {
                let decodedImage = UIImage(data: data)
                return decodedImage
            }
        }
        
        return UIImage(named: "ImagePlaceholder")
    }

    func mockOngMariaHelena() -> Organizacao {
        let ong = Organizacao(nome: "Casa Maria Helena Paulina",
                              cnpj: "69.107.142/0001-59",
                              descricao: "A Casa Maria Helena Paulina é uma organização não governamental paulista fundada em 1992 que acolhe jovens com câncer - ou outras enfermidades - e seus acompanhantes oriundos de diversos estados brasileiros que encaminham-se para São Paulo em busca de infraestrutura de tratamento adequado às suas necessidades. A Casa fornece moradia, alimentos, assistência psicológica, produtos de higiene e as mais variadas atividades para que a estadia dos assistidos seja a melhor possível apesar de todas as dificuldades encontradas ao longo do tratamento.",
                              telefone: "(11) 3744-7492",
                              email: "contato@casamariahelenapaulina.org.br",
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

