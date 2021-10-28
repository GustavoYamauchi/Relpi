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
    
    let mode: Mode
    let usuario: Usuario

    @Published var email = ""
    @Published var senha = ""
    @Published var confirmarSenha = ""
    @Published var mensagem = ""
    @Published var apresentarAlerta = false
    
    private let userService: UserServiceProtocol
    
    @Published var encaminharOngForm = false
    @Published var encaminharOngHome = false
        
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
    
    func createOng(idOng: String) -> Organizacao {
        return Organizacao(id: idOng, nome: "", cnpj: "", descricao: "", telefone: "", email: "",
                           data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
                              endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
    }
    
    func getOng(idOng: String) -> Organizacao {
//        ongService.getOng()
        return Organizacao(id: idOng, nome: "Vai ser implementado", cnpj: "", descricao: "", telefone: "", email: "",
                           data: Timestamp(date: Date()),  banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
                              endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
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
