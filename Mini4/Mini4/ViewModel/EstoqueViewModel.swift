//
//  EstoqueViewModel.swift
//  Mini4
//
//  Created by Gustavo Rigor on 05/10/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore


class EstoqueViewModel : ObservableObject {
    @Published var data = [Item]()

    //for reading purpose it will automatically add data when we write data to firestore.
    private var dbEstoque = Firestore.firestore().collection("Ong")
    
    
    init(_ idOng: String) {
        dbEstoque = Firestore.firestore().collection("Ong").document(idOng).collection("estoque")
        
        dbEstoque.addSnapshotListener({ (snap_, err) in
            guard let snap = snap_ else {return}
            
            if let erro = err {
                print(erro.localizedDescription)
                return
            }
            
            for i in snap.documentChanges{
                if i.type == .added{
                    let msgData = Item(
                        id: i.document.documentID,
                        nome: self.castString(i.document.get("nome")),
                        quantidade: self.castInt(i.document.get("numero")),
                        urgente: self.castBool(i.document.get("urgente")),
                        visivel: self.castBool(i.document.get("visivel"))
                    )
                    self.data.append(msgData)
                }
                if i.type == .modified{
                    for j in 0..<self.data.count{
                        if self.data[j].id == i.document.documentID{
                            self.data[j].nome = self.castString(i.document.get("nome"))
                            self.data[j].quantidade = self.castInt(i.document.get("numero"))
                            self.data[j].urgente = self.castBool(i.document.get("urgente"))
                            self.data[j].visivel = self.castBool(i.document.get("visivel"))
                        }
                    }
                }
                if i.type == .removed{
                    self.data.remove(at: self.data.firstIndex(where: { item in
                        i.document.documentID == item.id
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
    
    func castInt(_ variable: Any?) -> Int{
        if let int = variable as? Int{
            return int
        }
        return 0
    }
    
    func castBool(_ variable: Any?) -> Bool{
        if let bool = variable as? Bool{
            return bool
        }
        return false
    }
    
    func addItemData(item: Item){
        let itemNovo = dbEstoque.document()
        
        itemNovo.setData([
            "id": itemNovo.documentID,
            "nome":  self.castString(item.nome),
            "quantidade":  item.quantidade,
            "urgente":  item.urgente,
            "visivel":  item.visivel
        ]) { (err) in
            if let erro = err?.localizedDescription {
                print(erro)
                return
            }
        }
    }
    
    func updateItem(item: Item) {
        dbEstoque.document(castString(item.id)).updateData(
            [
                "nome": item.nome,
                "quantidade": item.quantidade,
                "urgente": item.urgente,
                "visivel": item.visivel
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


