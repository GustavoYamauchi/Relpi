//
//  LoginViewModel.swift
//  Mini4
//
//  Created by Beatriz Sato on 22/10/21.
//

import Foundation
import FirebaseAuth
import Firebase

class LoginViewModel: ObservableObject {
    
    var auth = Auth.auth()
    
    var isAuthenticated: Bool {
        return auth.currentUser != nil
    }
    
    var id: String {
        return auth.currentUser?.uid ?? ""
    }
    
    @Published var autenticado = false
    var cadastrado = false
    
    var mensagem = String()
    
    
    func login(email: String, senha: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        auth.signIn(withEmail: email, password: senha) { [weak self] authResult, error in
            if let err = error {
                print(err.localizedDescription)
                self?.mensagem = err.localizedDescription
                completion(.failure(err))
            }
            
            if authResult?.user.uid != nil {
                DispatchQueue.main.async {
                    self?.autenticado = true
                    completion(.success(authResult!))
                }
            }
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
            DispatchQueue.main.async {
                self.autenticado = false
            }
            
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    
    func cadastrar(email: String, senha: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        auth.createUser(withEmail: email, password: senha) { [weak self] authResult, error in
            if let err = error {
                self?.mensagem = err.localizedDescription
                print("erro")
                completion(.failure(err))
            }
            
            if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
}
