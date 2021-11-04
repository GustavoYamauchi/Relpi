//
//  FormItemViewModel.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 03/11/21.
//

import SwiftUI
import Firebase

final class FormItemViewModel: ObservableObject {
    
    // MARK: - Propriedades
    
    let modo: Modo
    let estoqueService: EstoqueServiceProtocol
    let idOng: String
    
    
    // MARK: - Views
    
    var titulo: String {
        switch modo {
        case .editarItem:
            return "Editar Item"
        case .novoItem:
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
    
    
    // MARK: - Métodos
    
    init(idOng: String, idItem: String, modo: Modo, estoqueService: EstoqueServiceProtocol = EstoqueService()) {
        self.modo = modo
        self.estoqueService = estoqueService
        self.idOng = idOng
        self.item = Item(nome: "", categoria: "", quantidade: 1, urgente: false, visivel: true)
        
        if modo == .editarItem && !idItem.isEmpty {
            fetchItem(idOng: idOng, idItem: idItem)
        }
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
    
    func salvar() {
        switch modo {
        case .editarItem:
            atualizarItem()
            
        case .novoItem:
            adicionarItem()
        }
    }
    
    func adicionarItem() {
        estoqueService.addItem(idOng: idOng, item: item) { result in
            switch result {
                case .success():
                    print("item adicionado")
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    
            }
        }
    }
    
    func atualizarItem() {
        estoqueService.updateItem(idOng: idOng, item: item) { result in
            switch result {
                case .success():
                    print("item atualizado")
                    
                case .failure(let err):
                    print(err.localizedDescription)
                    
            }
        }
    }
    
    func excluirItem() {
        estoqueService.deleteItem(idOng: idOng, idItem: item.id!) { result in
            switch result {
                case .success():
                    print("item excluído")
                    // atualizar timestamp da ong
                    
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
