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
    func create(_ ong: Organizacao) -> AnyPublisher<Void, Error>
}

final class OngService: OngServiceProtocol{
    private let db = Firestore.firestore()
    
    func create(_ ong: Organizacao) -> AnyPublisher<Void, Error> {
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
