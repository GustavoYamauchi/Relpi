//
//  OngHomeViewModel.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 30/10/21.
//

import SwiftUI
import Firebase

// primeiro lugar que carrega a view, source of truth?
// nas outras telas, usa o binding?

final class OngHomeViewModel: ObservableObject {
    
    let ongService: OngServiceProtocol
    
    @Published var ong: Organizacao
    @Published var selectedImage: UIImage
        
    // MARK: Inicializador
    
    init(idOng: String, ongService: OngServiceProtocol = OngService()) {
        self.ongService = ongService
        
        selectedImage = UIImage(named: "ImagePlaceholder") ?? UIImage(systemName: "camera")!
        
        self.ong = Organizacao(id: idOng, nome: "", cnpj: "", descricao: "", telefone: "", email: "", foto: "", data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""), endereco: Endereco( logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""), estoque: [Item]())
        
        fetchOng(idOng: idOng)
        
    }
    
    
    // MARK: Elementos da View
    
    var bemVindoLabel: String {
        return "Bem-vindo!"
    }
    
    var nomeOngLabel: String {
        return ong.nome
    }
    
    var listaButtonLabel: String {
        return "Lista Completa"
    }
    
    var sobreOngLabel: String {
        return "Sobre a ONG"
    }
    
    var verPerfilButtonLabel: String {
        return "Ver perfil"
    }
    
    var logoutLabel: String {
        return "Logout"
    }
    
    
    // MARK: Métodos
    
    private func fetchOng(idOng: String) {
        ongService.getOng(idOng: idOng) { [weak self] result in

            switch result {
            case .success(let ong):
                    self?.ong = ong
                    self?.fetchImage()

            case .failure(let err):
                print(err.localizedDescription)
            }
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
}
