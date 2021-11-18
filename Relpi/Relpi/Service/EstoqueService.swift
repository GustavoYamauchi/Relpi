//
//  EstoqueServiceProtocol.swift
//  Mini4
//
//  Created by Beatriz Sato on 02/11/21.
//

import Firebase
import FirebaseFirestore

protocol EstoqueServiceProtocol {
    func addItem(idOng: String, item: Item, completion: @escaping (Result<Void, Error>) -> Void)
    func getItems(idOng: String, completion: @escaping (Result<[Item], Error>) -> Void)
    func getItem(idOng: String, idItem: String, completion: @escaping (Result<Item, Error>) -> Void)
    func updateItem(idOng: String, item: Item, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteItem(idOng: String, idItem: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateDate(idOng: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class EstoqueService: EstoqueServiceProtocol {

    private let ongRef = Firestore.firestore().collection("ong")
    
    func addItem(idOng: String, item: Item, completion: @escaping (Result<Void, Error>) -> Void) {
        print("tenta adicionar item")
        let itemNovo = ongRef.document(idOng).collection("estoque").document()
        let id = itemNovo.documentID
        
        itemNovo.setData([
            "id": id,
            "nome":  self.castString(item.nome),
            "categoria":  self.castString(item.categoria),
            "quantidade":  item.quantidade,
            "urgente":  item.urgente,
            "visivel":  item.visivel
        ]) { (err) in
            if let erro = err {
                completion(.failure(erro))
            }
        }
        
        updateDate(idOng: idOng){ result in
            switch result {
            case .success(()):
                print("data Atualizada")
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
        
        completion(.success(()))
    }
    
    func getItems(idOng: String, completion: @escaping (Result<[Item], Error>) -> Void) {
        // pegar todos os itens da coleção "estoque" do documento referente à idOng
        ongRef.document(idOng).collection("estoque").getDocuments { (snapshot, err) in
            if let err = err {
                completion(.failure(err))
            }
            
            do {
                let itens = try snapshot?.documents.map {
                    try $0.data(as: Item.self)
                }
                                
                if let itensExistentes = itens?.compactMap({ $0 }) {
                    completion(.success(itensExistentes))
                }
                
            } catch let err {
                completion(.failure(err))
            }
        }
    }
    
    func getItem(idOng: String, idItem: String, completion: @escaping (Result<Item, Error>) -> Void) {
        // pegar todos os itens da coleção "estoque" do documento referente à idOng
        let query = ongRef.document(idOng).collection("estoque").whereField("id", isEqualTo: idItem)
        query.getDocuments { (snapshot, err) in
            if let err = err {
                completion(.failure(err))
            }
            
            do {
                let itens = try snapshot?.documents.map {
                    try $0.data(as: Item.self)
                }
                                
                if let item = itens?.first {
                    completion(.success(item!))
                }
                
            } catch let err {
                completion(.failure(err))
            }
        }
    }
    
    func updateItem(idOng: String, item: Item, completion: @escaping (Result<Void, Error>) -> Void) {
        ongRef.document(idOng).collection("estoque").document(item.id!).updateData([
            "nome": item.nome,
            "categoria": item.categoria,
            "quantidade": item.quantidade,
            "urgente": item.urgente,
            "visivel": item.visivel
        ]) { err in
            if let err = err {
                completion(.failure(err))
            }
        }
        
        updateDate(idOng: idOng){ result in
            switch result {
            case .success(()):
                print("data Atualizada")
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
        
        completion(.success(()))
    }
    
    func deleteItem(idOng: String, idItem: String, completion: @escaping (Result<Void, Error>) -> Void) {
 
        ongRef.document(idOng).collection("estoque").document(idItem).delete { erro in
            if let err = erro {
                completion(.failure(err))
            }
        }
        
        updateDate(idOng: idOng){ result in
            switch result {
            case .success(()):
                print("data Atualizada")
            case .failure(let err):
                print(err.localizedDescription)
            }

        }
        
        completion(.success(()))
    }
    
    func updateDate(idOng: String, completion: @escaping (Result<Void, Error>) -> Void){
        ongRef.document(idOng).updateData(["data": Timestamp(date: Date())]){ err in
            if let err = err {
                completion(.failure(err))
            }
        }
        completion(.success(()))
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
}
