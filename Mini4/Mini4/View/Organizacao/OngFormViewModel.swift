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
//    let ongService: OngServiceProtocol
    
    @Published var ong: Organizacao
    @Published var selectedImage: UIImage
    
    init(modo: Modo, userService: UserServiceProtocol = UserService()) {
        self.modo = modo
        self.userService = userService
        
        selectedImage = UIImage(named: "ImagePlaceholder") ?? UIImage(systemName: "camera")!
 
        if modo == .cadastro {
            ong = Organizacao(id: userService.usuarioAtual()?.uid,
                nome: "Nova Ong", cnpj: "", descricao: "", telefone: "", email: "",
                data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
                endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
            
        } else {
            // TODO: pega do firebase
            ong = Organizacao(id: userService.usuarioAtual()?.uid,
                nome: "", cnpj: "", descricao: "", telefone: "", email: "",
                data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
                endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
            
            fetchImage()
        }
    }
    
    func fetchImage() {
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
    
    func salvar() {
        if modo == .cadastro {
            // adiciona no firebase
            print("adiciona no firebase")
//            ongService.create
        } else {
            // atualiza no firebase
            print("atualiza no firebase")
        }
    }
}

extension OngFormViewModel {
    enum Modo {
        case cadastro
        case perfil
    }
}
