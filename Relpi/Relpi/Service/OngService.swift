//
//  OngService.swift
//  Mini4
//
//  Created by Gustavo Rigor on 28/10/21.
//

import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol OngServiceProtocol {
    func create(_ ong: Organizacao, completion: @escaping (Result<Void, Error>) -> Void)
    func getOng(idOng: String, completion: @escaping (Result<Organizacao, Error>) -> Void)
    func deleteOng(idOng: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchOngs(completion: @escaping (Result<[Organizacao], Error>) -> Void)
}

final class OngService: OngServiceProtocol {

    private let db = Firestore.firestore()
    
    // cria um novo e atualiza
    func create(_ ong: Organizacao, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let id = ong.id {
                var newOng = ong
                newOng.estoque = nil
                _ = try self.db.collection("ong").document(id).setData(from: newOng)
                    completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getOng(idOng: String, completion: @escaping (Result<Organizacao, Error>) -> Void) {
        let query = db.collection("ong").whereField("id", isEqualTo: idOng)
        query.getDocuments { (snapshot, err) in
            if let err = err {
                completion(.failure(err))
            }
            
            do {
                let ongs = try snapshot?.documents.map {
                    try $0.data(as: Organizacao.self)
                }
                
                guard let ong = ongs?.first else { return }

                completion(.success(ong!))
                
            } catch let error {
                completion(.failure(error))
            }
        }
    }

    func fetchOngs(completion: @escaping (Result<[Organizacao], Error>) -> Void) {
        db.collection("ong").getDocuments { (snapshot, err) in
            if let err = err {
                completion(.failure(err))
            }
            
            do {
                let ongs = try snapshot?.documents.map {
                    try $0.data(as: Organizacao.self)
                }
                
                if let ongsExistentes = ongs?.compactMap({ $0 }) {
                    completion(.success(ongsExistentes))
                }
                
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func deleteOng(idOng: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.document(idOng).delete{ erro in
            if let err = erro {
                completion(.failure(err))
            }
            
            completion(.success(()))
        }
    }
    
}
