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
    
    var mensagem = String()
    
    
    init() {
        print("LoginViewModel: \(auth.currentUser?.uid)")
    }
    
    func login(email: String, senha: String) {
        Auth.auth().signIn(withEmail: email, password: senha) { [weak self] authResult, error in
            if let err = error {
                print(err.localizedDescription)
                self?.mensagem = err.localizedDescription
                
            }
            
            if authResult?.user.uid != nil {
                DispatchQueue.main.async {
                    self?.autenticado = true
                }
            }
        }
    }
    
    func cadastrar(email: String, senha: String) {
        Auth.auth().createUser(withEmail: email, password: senha) { [weak self] authResult, error in
            if let err = error {
                self?.mensagem = err.localizedDescription
            }
            
            if authResult != nil {
                DispatchQueue.main.async {
                    self?.autenticado = true
                }
            }
        }
    }
}
