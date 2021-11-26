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
    @Published var listaVertical = true
    @Published var listaCategorizada = false
    @Published var mostrarFiltros = false
    @Published var apenasUrgente = false

    //for reading purpose it will automatically add data when we write data to firestore.
    private var dbEstoque = Firestore.firestore().collection("ng")
    
    
    init(_ idOng: String) {
        dbEstoque = Firestore.firestore().collection("ong").document(idOng).collection("estoque")
        
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
                                    categoria: self.castString(i.document.get("categoria")),
                                    quantidade: self.castInt(i.document.get("quantidade")),
                                    urgente: self.castBool(i.document.get("urgente")),
                                    visivel: self.castBool(i.document.get("visivel"))
                                )
                                self.data.append(msgData)
                            }
                            if i.type == .modified{
                                for j in 0..<self.data.count{
                                    if self.data[j].id == i.document.documentID{
                                        self.data[j].nome = self.castString(i.document.get("nome"))
                                        self.data[j].categoria = self.castString(i.document.get("categoria"))
                                        self.data[j].quantidade = self.castInt(i.document.get("quantidade"))
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
            "categoria":  self.castString(item.categoria),
            "quantidade":  item.quantidade,
            "urgente":  item.urgente,
            "visivel":  item.visivel
        ]) { (err) in
            if let erro = err?.localizedDescription {
                print(erro)
                return
            }
        }
        atualizarTimestamp()
    }
    
    func updateItem(item: Item) {
        dbEstoque.document(castString(item.id)).updateData(
            [
                "nome": item.nome,
                "categoria": item.categoria,
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
        //atualizarTimestamp()
    }
    
    func deleteItem(item: Item){
        if let id = item.id{
            dbEstoque.document(id).delete{ erro in
                if let err = erro {
                    print(err.localizedDescription)
                    return
                }
            }
        }
        atualizarTimestamp()
    }
    
    func atualizarTimestamp(){
        if let attEstoque = dbEstoque.parent{
            attEstoque.updateData(["data" : Timestamp(date: Date())])
        }
    }
    
    func temItemNaCategoria(categoria: Categorias, itemPesquisado: String) -> Bool{
        let filtro = data.filter({ ($0.nome.contains("\(itemPesquisado)") || itemPesquisado.isEmpty) && $0.categoria == categoria.rawValue && $0.visivel  && ($0.urgente || !apenasUrgente)})
        print("filtro: \(filtro.count) de \(filtro.first?.categoria ?? "")")
        return filtro.count > 0
    }
    
}

//enum Categorias : String{
//    case higiene = "Higiene"
//    case alimento = "Alimento"
//    case limpeza = "Limpeza"
//    case medicamento = "Medicamento"
//    case utensilio = "Utensilio"
//    case vazio = ""
//    var categoria: Categorias {
//        switch self {
//        case .higiene, .alimento, .limpeza, .medicamento, .utensilio:
//            return self
//        default:
//            return .vazio
//        }
//    }
//    var titulo: String {
//        switch self {
//        case .higiene: return "Higiene pessoal"
//        case .alimento: return "Alimento"
//        case .limpeza: return "Produtos de limpeza"
//        case .medicamento: return "Medicamentos"
//        case .utensilio: return "Utensílios de cozinha"
//        default:
//            return ""
//        }
//    }
//    
//}


