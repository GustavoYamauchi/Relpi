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
    
    // to create and write data on firestore
    func addData(msg: String){
        let msg1 = dbOng.document()
        
        msg1.setData(["id" : msg1.documentID, "cnpj":msg]){ (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            print("sucess")
        }
    }
    
    func updateData(id: String, txt: String) {
        dbOng.document(id).updateData(["cnpj": txt]){ (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            print("success")
        }
    }
    
}
