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
    @Published var selectedImage: UIImage
    @Published var redirectHome = false
    @Published var apresentaFeedback = false
    @Published var mensagem = ""
    var cor: ColorStyle = .green
        
    // MARK: - Inicializador
    
    init(modo: Modo,
         userService: UserServiceProtocol = UserService(),
         ongService: OngServiceProtocol = OngService())
    {
        self.modo = modo
        self.userService = userService
        self.ongService = ongService
        
        selectedImage = UIImage(named: "ImagePlaceholder") ?? UIImage(systemName: "camera")!
 
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

    func salvar() {
        switch modo {
            case .cadastro:
            ImageStorageService.shared.uploadImage(orgName: ong.nome, image: selectedImage) { [weak self] imageUrl, err in
                if let err = err {
                    self?.mensagem = err.localizedDescription
                    self?.apresentaFeedback = true
                }

                self?.ong.foto = imageUrl
                
                // adiciona no firebase
                self?.ongService.create(self!.ong) { [weak self] result in
                    switch result {
                        case .success:
                            self?.redirectHome = true
                            
                        case .failure(let err):
                            self?.mensagem = err.localizedDescription
                            self?.apresentaFeedback = true
                    }
                }
            }
            
            case .perfil:
                // atualiza no firebase
                self.ongService.create(self.ong) { [weak self] result in
                    switch result {
                        case .success:
                            self?.mensagem = "Atualizado com sucesso!"
                            self?.apresentaFeedback = true
                            
                        case .failure(let err):
                            self?.mensagem = err.localizedDescription
                            self?.apresentaFeedback = true
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

