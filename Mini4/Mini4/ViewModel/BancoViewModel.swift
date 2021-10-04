//
//  BancoViewModel.swift
//  Mini4
//
//  Created by Gustavo Rigor on 04/10/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore


class BancoViewModel : ObservableObject {
    @Published var data = [Banco]()

    //for reading purpose it will automatically add data when we write data to firestore.
    private var dbBanco = Firestore.firestore().collection("Ong")
    
    
    init(_ idOng: String) {
        dbBanco = Firestore.firestore().collection("Ong").document(idOng).collection("banco")
        
        dbBanco.addSnapshotListener({ (snap_, err) in
            guard let snap = snap_ else {return}
            
            if let erro = err {
                print(erro.localizedDescription)
                return
            }
            
            for i in snap.documentChanges{
                if i.type == .added{
                    let msgData = Banco(
                        id: i.document.documentID,
                        banco: self.castString(i.document.get("banco")),
                        agencia: self.castString(i.document.get("agencia")),
                        conta: self.castString(i.document.get("conta")),
                        pix: self.castString(i.document.get("pix"))
                    )
                    self.data.append(msgData)
                }
                if i.type == .modified{
                    for j in 0..<self.data.count{
                        if self.data[j].id == i.document.documentID{
                            self.data[j].banco = self.castString(i.document.get("banco"))
                            self.data[j].agencia = self.castString(i.document.get("agencia"))
                            self.data[j].conta = self.castString(i.document.get("conta"))
                            self.data[j].pix = self.castString(i.document.get("pix"))
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
    
    func addBancoData(banco: Banco){
        let dbBanco = dbBanco.document("principal")
        
        dbBanco.setData([
            "id": dbBanco.documentID,
            "banco": self.castString(banco.banco),
            "agencia": self.castString(banco.agencia),
            "conta": self.castString(banco.conta),
            "pix": self.castString(banco.pix)
        ]) { (err) in
            if let erro = err?.localizedDescription {
                print(erro)
                return
            }
        }
    }
    
    func updateBanco(banco: Banco) {
        dbBanco.document("principal").updateData(
            [
                "banco": banco.banco,
                "agencia": banco.agencia ?? "...",
                "conta": banco.conta ?? "...",
                "pix": banco.pix ?? "..."
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
