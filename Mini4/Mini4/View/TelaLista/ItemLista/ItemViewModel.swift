//
//  ItemListaViewModel.swift
//  Mini4
//
//  Created by Beatriz Sato on 03/11/21.
//

import SwiftUI
import Firebase

final class ItemViewModel: ObservableObject {
    let estoqueService: EstoqueServiceProtocol
    let idOng: String
    
    @Published var item: Item
    
    
    // MARK: - Views
    var titulo: String {
        return item.nome
    }
    
    var imagemNome: String {
        if item.categoria.isEmpty {
            return "alimentoIcon"
        }
        return "\(item.categoria.lowercased())Icon"
    }
    
    
    // MARK: - Inicializador
    
    init(idOng: String, idItem: String, estoqueService: EstoqueServiceProtocol = EstoqueService()) {
        self.idOng = idOng
        self.estoqueService = estoqueService
        self.item = Item(id: idItem, nome: "", categoria: "", quantidade: 0, urgente: false, visivel: false)
        self.fetchItem(idOng: idOng, idItem: idItem)
    }
    
    
    // MARK: - Métodos
    
    private func fetchItem(idOng: String, idItem: String) {
        estoqueService.getItem(idOng: idOng, idItem: idItem) { [weak self] result in
            switch result {
                case .success(let item):
                    DispatchQueue.main.async {
                        self?.item = item
                    }
                    
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
