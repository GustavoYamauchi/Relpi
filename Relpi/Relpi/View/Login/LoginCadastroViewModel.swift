//
//  LoginCadastroViewModel.swift
//  Mini4
//
//  Created by Beatriz Sato on 27/10/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

class LoginCadastroViewModel: ObservableObject {
    
    private let userService: UserServiceProtocol
    
    let mode: Mode
    let usuario: Usuario
    
    var id: String? {
        return userService.usuarioAtual()?.uid
    }

    // elementos do formulário
    
    @Published var email = ""
    @Published var senha = ""
    @Published var confirmarSenha = ""
    @Published var mensagem = ""
    
    // controlador de estado
    
    @Published var apresentarAlerta = false
    @Published var encaminharOngForm = false
    @Published var encaminharOngHome = false
    
        
    // MARK: Inicializador
    
    init(mode: Mode, usuario: Usuario, userService: UserServiceProtocol = UserService()) {
        self.mode = mode
        self.usuario = usuario
        self.userService = userService
    }
    
    
    // MARK: Elementos da View
    
    var titulo: String {
        switch mode {
        case .cadastro:
            return usuario == .ong ? "Cadastre a sua ONG" : "Crie sua conta"
        default:
            return usuario == .ong ? "Entrar na sua ONG" : "Login"
        }
    }
    
    var botaoCadastrarEntrar: String {
        switch mode {
        case .cadastro:
            return "Cadastrar"
        
        default:
            return "Entrar"
        }
    }
    
    var temContaLabel: String {
        switch mode {
        case .cadastro:
            return "Já possui uma conta?"
        
        default:
            return "Ainda não possui uma conta?"
        }
    }
    
    var temContaBotaoLabel: String {
        switch mode {
        case .cadastro:
            return "Entrar"
        
        default:
            return "Cadastrar"
        }
    }
    
    // MARK: User intent (ações do usuário)
    
    func cadastrarLogar() {
        switch mode {
        case .cadastro:
             print("Cadastrar")
            if senha == confirmarSenha {
                userService.cadastrar(email: email, senha: senha) { [weak self] result in
                    switch result {
                    case .success(let user):
                        print(user.uid)
                        self?.encaminharOngForm = true
                        
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
                    print(user.uid)
                    self?.encaminharOngHome = true
                    
                case .failure(let err):
                    self?.mensagem = err.localizedDescription
                    self?.apresentarAlerta = true
                }
            }
        }
    }
    
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
