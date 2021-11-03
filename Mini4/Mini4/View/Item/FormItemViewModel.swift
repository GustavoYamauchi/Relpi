//
//  FormItemViewModel.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 03/11/21.
//

import SwiftUI
import Firebase

final class FormItemViewModel: ObservableObject {
    let modo: Modo
    let estoqueService: EstoqueServiceProtocol
    let idOng: String
    
    var titulo: String {
        switch modo {
        case .editarItem:
            return "Editar Item"
        default:
            return "Novo Item"
        }
    }
    
    var imagemNome: String {
        if item.categoria.isEmpty {
            return "alimentoIcon"
        }
        return "\(item.categoria.lowercased())Icon"
    }
    
    @Published var item: Item
    
    init(idOng: String, idItem: String, modo: Modo, estoqueService: EstoqueServiceProtocol = EstoqueService()) {
        self.modo = modo
        self.estoqueService = estoqueService
        self.idOng = idOng
        self.item = Item(nome: "", categoria: "", quantidade: 1, urgente: false, visivel: true)
        
        if modo == .editarItem && !idItem.isEmpty {
            fetchItem(idOng: idOng, idItem: idItem)
        }
    }

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


extension FormItemViewModel {
    enum Modo {
        case novoItem
        case editarItem
    }
}
