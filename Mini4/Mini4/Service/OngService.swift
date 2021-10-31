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
}

final class OngService: OngServiceProtocol{

    private let db = Firestore.firestore()
    
    func create(_ ong: Organizacao, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let id = ong.id {
                _ = try self.db.collection("ong").document(id).setData(from: ong)
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

                DispatchQueue.main.async {
                    print("pegou ong")
                    completion(.success(ong!))
                }
                
            } catch let error {
                completion(.failure(error))
            }
            
        }
    }
    
    func createCombine(_ ong: Organizacao) -> AnyPublisher<Void, Error> {
        return Future<Void, Error>{ promise in
            do{
                _ = try self.db.collection("ong").addDocument(from: ong)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
