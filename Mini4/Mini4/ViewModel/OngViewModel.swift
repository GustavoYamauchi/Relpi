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
    private let dbOng = Firestore.firestore().collection("Ong")
    
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
                        foto: self.castString(i.document.get("foto"))
                    )
                    self.data.append(msgData)
                }
                if i.type == .modified{
                    for j in 0..<self.data.count{
                        if self.data[j].id == i.document.documentID{
                            self.data[j].cnpj = (i.document.get("cnpj") as! String)
                            self.data[j].nome = self.castString(i.document.get("nome"))
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
    
    func addOrgData(org: Organizacao){
        let ong1 = dbOng.document()
        let banco = dbOng.document(ong1.documentID).collection("banco").document("principal")
        let endereco = dbOng.document(ong1.documentID).collection("endereco").document("principal")
        let estoque = dbOng.document(ong1.documentID).collection("estoque").document("principal")
        
        ong1.setData([
            "id" : ong1.documentID,
            "nome": org.nome,
            "cnpj": org.cnpj,
            "descricao": org.descricao,
            "telefone": org.telefone
        ]) { (err) in
            if let erro = err?.localizedDescription {
                print(erro)
                return
            }
        }
        
        banco.setData([
            "id": banco.documentID,
            "banco": "...",
            "agencia": "...",
            "conta": "...",
            "pix": "..."
        ]) { (err) in
            if let erro = err?.localizedDescription {
                print(erro)
                return
            }
        }
        
        endereco.setData([
            "id": endereco.documentID,
            "logradouro": "...",
            "numero": "...",
            "complemento": "...",
            "bairro": "...",
            "cidade": "...",
            "cep": 0
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
             "telefone": ong.telefone
            ]
        ){ (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            print("success")
        }
    }
    
}
