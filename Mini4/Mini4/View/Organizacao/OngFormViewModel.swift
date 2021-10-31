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
    
    init(modo: Modo,
         userService: UserServiceProtocol = UserService(),
         ongService: OngServiceProtocol = OngService())
    {
        self.modo = modo
        self.userService = userService
        self.ongService = ongService
        
        selectedImage = UIImage(named: "ImagePlaceholder") ?? UIImage(systemName: "camera")!
 
        if modo == .cadastro {
            ong = Organizacao(id: userService.usuarioAtual()?.uid,
                nome: "Nova Ong", cnpj: "", descricao: "", telefone: "", email: "",
                data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
                endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
            
        } else {
            // TODO: pega do firebase
            ong = Organizacao(id: userService.usuarioAtual()?.uid,
                nome: "antes de pegar", cnpj: "", descricao: "", telefone: "", email: "",
                data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
                endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
            
            if let id = userService.usuarioAtual()?.uid {
                print("pegando ong da viewmodel")
                fetchOng(idOng: id)
            }
            
            fetchImage()
        }
    }
    
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

            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }

    func salvar() {
        if modo == .cadastro {
            // adiciona no firebase
            print("adiciona no firebase")
            ongService.create(ong) { result in
                switch result {
                    case .success:
                        print("cadastrado com sucesso")
                    case .failure(let err):
                        print(err.localizedDescription)
                }
            }
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

