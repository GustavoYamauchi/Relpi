//
//  LoginCadastroViewModel.swift
//  Mini4
//
//  Created by Beatriz Sato on 27/10/21.
//

import SwiftUI

class LoginCadastroViewModel: ObservableObject {
    
    let mode: Mode
    let usuario: Usuario

    @Published var email = ""
    @Published var senha = ""
    @Published var confirmarSenha = ""
    @Published var mensagem = ""
    @Published var apresentarAlerta = false
    
    private let userService: UserServiceProtocol
    
    @Published var encaminharOngForm = false
    
    init(mode: Mode, usuario: Usuario, userService: UserServiceProtocol = UserService()) {
        self.mode = mode
        self.usuario = usuario
        self.userService = userService
    }
    
    var titulo: String {
        switch mode {
        case .cadastro:
            return usuario == .ong ? "Cadastre a sua ONG" : "Crie sua conta"
        default:
            return usuario == .ong ? "Entrar na sua ONG" : "Login"
        }
    }
    
    var botao: String {
        switch mode {
        case .cadastro:
            return "Cadastrar"
        
        default:
            return "Entrar"
        }
    }
    
    var rodape: String {
        switch mode {
        case .cadastro:
            return "Já possui uma conta?"
        
        default:
            return "Ainda não possui uma conta?"
        }
    }
    
    var botaoRodape: String {
        switch mode {
        case .cadastro:
            return "Entrar"
        
        default:
            return "Cadastrar"
        }
    }
    
    func botaoApertado() {
        switch mode {
        case .cadastro:
             print("Cadastrar")
            if senha == confirmarSenha {
                userService.cadastrar(email: email, senha: senha) { [weak self] result in
                    switch result {
                    case .success(let user):
                        user.uid
                        
                    case .failure(let err):
                        self?.mensagem = err.localizedDescription
                        self?.apresentarAlerta = true
                    }
                }
            } else {
                self.mensagem = "As senhas não são compatíveis"
                self.apresentarAlerta = true
            }

        
        default:
            print("Entrar")
            userService.login(email: email, senha: senha) { [weak self] result in
                switch result {
                case .success(let user):
                    user.uid
                    
                case .failure(let err):
                    self?.mensagem = err.localizedDescription
                    self?.apresentarAlerta = true
                }
            }
        }
    }
    
//    func createOng(idOng: String)
}

extension LoginCadastroViewModel {
    enum Mode {
        case login
        case cadastro
    }
    
    enum Usuario {
        case ong
        case doador
    }
}
