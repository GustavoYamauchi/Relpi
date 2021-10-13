//
//  EnderecoViewModel.swift
//  Mini4
//
//  Created by Gustavo Rigor on 04/10/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore


class EnderecoViewModel : ObservableObject {
    @Published var data = [Endereco]()

    //for reading purpose it will automatically add data when we write data to firestore.
    private var dbEndereco = Firestore.firestore().collection("ong")
    
    
    init(_ idOng: String) {
        dbEndereco = Firestore.firestore().collection("ong").document(idOng).collection("endereco")
        
        dbEndereco.addSnapshotListener({ (snap_, err) in
            guard let snap = snap_ else {return}
            
            if let erro = err {
                print(erro.localizedDescription)
                return
            }
            
            for i in snap.documentChanges{
                if i.type == .added{
                    let msgData = Endereco(
                        id: i.document.documentID,
                        logradouro: self.castString(i.document.get("logradouro")),
                        numero: self.castString(i.document.get("numero")),
                        bairro: self.castString(i.document.get("bairro")),
                        cidade: self.castString(i.document.get("cidade")),
                        cep: self.castString(i.document.get("cep")),
                        estado: self.castString(i.document.get("estado"))
                    )
                    self.data.append(msgData)
                }
                if i.type == .modified{
                    for j in 0..<self.data.count{
                        if self.data[j].id == i.document.documentID{
                            self.data[j].logradouro = self.castString(i.document.get("logradouro"))
                            self.data[j].numero = self.castString(i.document.get("numero"))
                            self.data[j].bairro = self.castString(i.document.get("bairro"))
                            self.data[j].cidade = self.castString(i.document.get("cidade"))
                            self.data[j].cep = self.castString(i.document.get("cep"))
                            self.data[j].estado = self.castString(i.document.get("estado"))
                        }
                    }
                }
                if i.type == .removed{
                    self.data.remove(at: self.data.firstIndex(where: { endereco in
                        i.document.documentID == endereco.id
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
    
    func addEnderecoData(endereco: Endereco){
        let dbEndereco = dbEndereco.document("principal")
        
        dbEndereco.setData([
            "id": dbEndereco.documentID,
            "logradouro":  self.castString(endereco.logradouro),
            "numero":  self.castString(endereco.numero),
            "bairro":  self.castString(endereco.bairro),
            "cidade":  self.castString(endereco.cidade),
            "cep":  self.castString(endereco.cep),
            "estado": self.castString(endereco.estado)
        ]) { (err) in
            if let erro = err?.localizedDescription {
                print(erro)
                return
            }
        }
    }
    
    func updateEndereco(endereco: Endereco) {
        dbEndereco.document("principal").updateData(
            [
                "logradouro": endereco.logradouro,
                "numero": endereco.numero,
                "bairro": endereco.bairro,
                "cidade": endereco.cidade,
                "cep": endereco.cidade,
                "estado": endereco.estado
            ]
        ){ (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            print("success")
        }
    }
    
    func deleteEndereco(endereco: Endereco){
        if let id = endereco.id{
            dbEndereco.document(id).delete{ erro in
                if let err = erro {
                    print(err.localizedDescription)
                    return
                }
            }
        }
    }
    
}

