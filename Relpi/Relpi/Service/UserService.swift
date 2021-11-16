//
//  UserService.swift
//  Mini4
//
//  Created by Beatriz Sato on 27/10/21.
//

import FirebaseAuth

protocol UserServiceProtocol {
    func usuarioAtual() -> User?
    func cadastrar(email: String, senha: String, completion: @escaping (Result<User, Error>) -> Void)
    func login(email: String, senha: String, completion: @escaping (Result<User, Error>) -> Void)
    func logout()
//    func observarMudancasAutenticacao()
}

final class UserService: UserServiceProtocol {
    func usuarioAtual() -> User? {
        return Auth.auth().currentUser
    }
    
    func cadastrar(email: String, senha: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: senha) { authResult, error in
            if let err = error {
                completion(.failure(err))
            }
            
            if let authResult = authResult {
                completion(.success(authResult.user))
            }
        }
    }
    
    func login(email: String, senha: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: senha) { authResult, error in
            if let err = error {
                completion(.failure(err))
            }
            
            if authResult?.user.uid != nil {
                DispatchQueue.main.async {
                    completion(.success(authResult!.user))
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
            }
            
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    
}
