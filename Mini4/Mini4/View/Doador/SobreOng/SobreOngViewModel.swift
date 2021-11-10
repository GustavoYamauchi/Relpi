//
//  SobreOngViewModel.swift
//  Mini4
//
//  Created by Beatriz Sato on 08/11/21.
//

import SwiftUI
import Firebase

final class SobreOngViewModel: ObservableObject {
    private let ongService: OngServiceProtocol
    private let estoqueService: EstoqueServiceProtocol
    
    @Published var ong: Organizacao
    @Published var image: UIImage
    @Published var trocaTela: Bool = false
    
    init(ongService: OngServiceProtocol = OngService(),
         estoqueService: EstoqueServiceProtocol = EstoqueService(),
         ong: Organizacao) {
        self.ong = ong
        self.ongService = ongService
        self.estoqueService = estoqueService
        self.image = UIImage(named: "ImagePlaceholder") ?? UIImage(systemName: "camera")!
        
        fetchImage()
        fetchItems()
    }
    
    
    // MARK: - Views
    var nomeOng: String {
        return ong.nome
    }
    
    var cidade: String {
        return ong.endereco.cidade
    }
    
    var descricao: String {
        return ong.descricao
    }
    
    var data: Timestamp {
        return ong.data
    }
    
    var idOng: String {
        return ong.id!
    }
    
    private func fetchImage() {
        if let foto = ong.foto {
            ImageStorageService.shared.downloadImage(urlString: foto) { [weak self] image, err in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func fetchItems() {
        estoqueService.getItems(idOng: ong.id!) { result in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.ong.estoque = items
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func itensEstocados() -> Int {
        return ong.estoque?.count ?? 0
    }
}
