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
}

final class EstoqueService: EstoqueServiceProtocol {
    private let ongRef = Firestore.firestore().collection("ong")
    
    func addItem(idOng: String, item: Item, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try ongRef.document(idOng).collection("estoque").addDocument(from: item)
                completion(.success(()))
        } catch {
            completion(.failure(error))
        }
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
    
}
