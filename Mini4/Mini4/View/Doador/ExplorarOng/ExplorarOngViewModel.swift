//
//  ExplorarOngViewModel.swift
//  Mini4
//
//  Created by Beatriz Sato on 05/11/21.
//

import SwiftUI

final class ExplorarOngViewModel: ObservableObject {
    //MARK: - Properties & Variables
    let ongService: OngServiceProtocol
    
    var ongs = [Organizacao]()
    @Published var listaVertical = true
    @Published var mostrarFiltros = false
    var array = ["SP", "RJ"]
    @Published var estadoSelecionado = ""
    @Published var images: [String: UIImage] = [String: UIImage]()
    
    
    //MARK: - Inicializador
    
    init(ongs: [Organizacao], ongService: OngServiceProtocol = OngService()) {
        self.ongService = ongService
        self.ongs = ongs
        fetchImages()
    }
    
    
    //MARK: - Views
    
    var nomeImagemFiltro: String {
        return "filter"
    }
    
    var nomeImagemColecao: String {
        return "collection"
    }
    
    var nomeImagemTabela: String {
        return "table"
    }
    
    func getImage(from id: String) -> UIImage {
        if let image = images[id] {
            return image
        }
        return UIImage(named: "ImagePlaceholder") ?? UIImage(systemName: "camera")!
    }
    
    // MARK: - Método service
    func fetchImages() {
        for ong in ongs {
            if let foto = ong.foto {
                if foto != "" {
                    ImageStorageService.shared.downloadImage(urlString: foto) { [weak self] image, err in
                        if let err = err {
                            print(err.localizedDescription)
                        }
                        
                        if let image = image {
                            DispatchQueue.main.async {
                                self?.images[ong.id!] = image
                            }
                        }
                    }
                }
            }
        }
    }
    
}
