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
    var atualizaImagem = false
    var cor: ColorStyle = .green
        
    // MARK: - Inicializador
    
    init(modo: Modo,
         userService: UserServiceProtocol = UserService(),
         ongService: OngServiceProtocol = OngService())
    {
        self.modo = modo
        self.userService = userService
        self.ongService = ongService
         
        ong = Organizacao(id: userService.usuarioAtual()?.uid,
            nome: "", cnpj: "", descricao: "", telefone: "", email: "",
            data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
            endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
        
        if modo == .perfil {
            if let id = userService.usuarioAtual()?.uid {
                fetchOng(idOng: id)
            }
        }
    }
    
    // MARK: - Métodos
    
    private func fetchImage() {
        if let foto = ong.foto {
            ImageStorageService.shared.downloadImage(urlString: foto) { [weak self] image, err in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.selectedImage = image
                        self?.downloadedImage = image
                    }
                }
            }
        }
    }
    
    private func fetchOng(idOng: String) {
        ongService.getOng(idOng: idOng) { [weak self] result in

            switch result {
            case .success(let org):
                self?.ong = org
                self?.fetchImage()

            case .failure(let err):
                self?.cor = .red
                self?.mensagem = err.localizedDescription
            }
        }
    }
    
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
                } else {
                    salvaSemImagem()
                }
        }
        
    }
    
    private func salvaSemImagem() {
        // atualiza no firebase sem atualizar imagem
        self.ongService.create(self.ong) { [weak self] result in
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
    
    
    private func salvaComImagem() {
        if selectedImage != nil {
            ImageStorageService.shared.uploadImage(idOng: ong.id!, image: selectedImage!) { [weak self] imageUrl, err in
                if let err = err {
                    self?.mensagem = err.localizedDescription
                    self?.apresentaFeedback = true
                }
                
                self?.ong.foto = imageUrl
                self?.downloadedImage = self?.selectedImage
                
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
        }
    }
    
}

extension OngFormViewModel {
    enum Modo {
        case cadastro
        case perfil
    }
}

