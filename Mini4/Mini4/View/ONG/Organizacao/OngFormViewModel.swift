//
//  OngFormViewModel.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 28/10/21.
//

import SwiftUI
import Firebase

class OngFormViewModel: ObservableObject {
    let modo: Modo
    
    let userService: UserServiceProtocol
    let ongService: OngServiceProtocol
    
    @Published var ong: Organizacao
    @Published var selectedImage: UIImage?
    var downloadedImage: UIImage?
    
    @Published var redirectHome = false
    @Published var apresentaFeedback = false
    @Published var mensagem = ""
    var cor: ColorStyle = .green
    @Published var isLoading = false
        
    // MARK: - Inicializador
    
    init(modo: Modo,
         userService: UserServiceProtocol = UserService(),
         ongService: OngServiceProtocol = OngService(),
         image: UIImage?,
         ongHome: Organizacao?
         )
    {
        self.modo = modo
        self.userService = userService
        self.ongService = ongService
        
        ong = Organizacao(id: userService.usuarioAtual()?.uid,
            nome: "", cnpj: "", descricao: "", telefone: "", email: "",
            data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
            endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
        
        
        if modo == .perfil {
            if let ong = ongHome {
                self.ong = ong
            }
            
            if let image = image {
                downloadedImage = image
            }
        }
        
    }
    
    // MARK: - Métodos
    
    func deleteOng() {
        ongService.deleteOng(idOng: ong.id!) { [weak self] result in
            switch result {
            case .success():
                print("deletado")
                // tem que ir pra cadastro view
                
            case .failure(let err):
                self?.mensagem = err.localizedDescription
                self?.cor = .red
                self?.apresentaFeedback = true
            }
        }
    
    }
    
    
    func salvar() {
        isLoading = true
        switch modo {
            case .cadastro:
                if selectedImage != nil {
                    salvaComImagem()
                } else {
                    salvaSemImagem()
                }
            case .perfil:
                // verifica se quer atualizar imagem
                if selectedImage != nil && selectedImage?.pngData() != downloadedImage?.pngData() {
                    salvaComImagem()
                    print("perfil com imagem")
                } else {
                    salvaSemImagem()
                }
        }
        isLoading = false
    }
    
    private func salvaSemImagem() {
        print("salvando sem imagem")
        // atualiza no firebase sem atualizar imagem
        self.ongService.create(self.ong) { [weak self] result in
            self?.isLoading = true
            switch result {
            case .success:
                if self?.modo == .cadastro {
                    self?.redirectHome = true
                    print("redirect home")
                    
                } else {
                    self?.mensagem = "Atualizado com sucesso!"
                    self?.apresentaFeedback = true
                }
                self?.isLoading = false
            case .failure(let err):
                self?.isLoading = false
                self?.mensagem = err.localizedDescription
                self?.apresentaFeedback = true
            }
        }
    }
    
    
    private func salvaComImagem() {
        if selectedImage != nil {
            print("fazendo upload de imagem")
            isLoading = true
            ImageStorageService.shared.uploadImage(idOng: ong.id!, image: selectedImage!) { [weak self] imageUrl, err in
                if let err = err {
                    self?.mensagem = err.localizedDescription
                    self?.apresentaFeedback = true
                }

                self?.ong.foto = imageUrl
                self?.downloadedImage = self?.selectedImage
                self?.selectedImage = nil

                // adiciona no firebase
                self?.ongService.create(self!.ong) { [weak self] result in
                    switch result {
                    case .success:
                        if self?.modo == .cadastro {
                            self?.redirectHome = true
                        } else {
                            self?.mensagem = "Atualizado com sucesso!"
                            self?.apresentaFeedback = true
                        }

                    case .failure(let err):
                        self?.mensagem = err.localizedDescription
                        self?.apresentaFeedback = true
                    }
                }
            }
            isLoading = false
        }
    }
    
}

extension OngFormViewModel {
    enum Modo {
        case cadastro
        case perfil
    }
}

