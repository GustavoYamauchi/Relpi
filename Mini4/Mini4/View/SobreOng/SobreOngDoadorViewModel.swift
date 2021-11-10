//
//  sobreOngDoadorViewModel.swift
//  Mini4
//
//  Created by Gustavo Rigor on 09/11/21.
//

import SwiftUI
import Firebase

final class SobreOngDoadorViewModel: ObservableObject {
    let ongService: OngServiceProtocol
    
    @Published var ong: Organizacao
    @Published var selectedImage: UIImage
    
    
    //MARK: - Elementos da View
    
    var nomeOngLabel: String {
        return ong.nome
    }
    
    var descricaoOngLabel: String{
        return ong.descricao
    }
    
    var enderecoOngLabel: String{
        return "\(ong.endereco.logradouro), \(ong.endereco.numero) - \(ong.endereco.bairro) - CEP \(ong.endereco.cep) - \(ong.endereco.cidade)/\(ong.endereco.estado)"
    }
    
    var telefoneOngLabel: String{
        return ong.telefone
    }
    
    var emailOngLabel: String{
        return ong.email
    }
    
    //MARK: - Inicializador
    
    init(idOng: String,
         ongService: OngServiceProtocol = OngService()
    ) {
        self.ongService = ongService
        
        selectedImage = UIImage(named: "ImagePlaceholder") ?? UIImage(systemName: "camera")!
        
        self.ong = Organizacao(id: idOng, nome: "", cnpj: "", descricao: "", telefone: "", email: "", foto: "", data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""), endereco: Endereco( logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""), estoque: [Item]())
        
        fetchOng(idOng: idOng)
    }
    
    //MARK: - Métodos
    
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
