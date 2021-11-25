//
//  FormItemViewModel.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 03/11/21.
//

import SwiftUI
import Firebase

final class FormItemViewModel: ObservableObject {
    
    let estoqueService: EstoqueServiceProtocol
    
    // MARK: - Propriedades
    @Published var item: Item
    var itemInicial: Item?

    let idOng: String
    let modo: Modo
    
    @Published var mensagem = ""
    @Published var apresentaFeedback = false
    var cor: ColorStyle = .green
    @Published var isLoading = false
    
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

    // MARK: - Inicializador
    // caso tenha item
    init(idOng: String,
         item: Item,
         modo: Modo = .editarItem,
         estoqueService: EstoqueServiceProtocol = EstoqueService())
    {
        self.idOng = idOng
        self.item = item
        self.modo = modo
        self.estoqueService = estoqueService
    }
    
    
    // caso não tenha item
    init(idOng: String,
         modo: Modo = .novoItem,
         estoqueService: EstoqueServiceProtocol = EstoqueService())
    {
        self.idOng = idOng
        self.modo = modo
        self.estoqueService = estoqueService
        item = Item(nome: "", categoria: "Alimento", quantidade: 1, urgente: false, visivel: true)
    }
    
    // MARK: - Métodos
    
    private func fetchItem(idOng: String, idItem: String) {
        estoqueService.getItem(idOng: idOng, idItem: idItem) { [weak self] result in
            switch result {
                case .success(let item):
                    DispatchQueue.main.async {
                        self?.item = item
                        self?.itemInicial = item
                    }
                    
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func salvar() {
        isLoading = true
        verificaCampos()
        if !apresentaFeedback{
            switch modo {
            case .editarItem:
                atualizarItem()
            case .novoItem:
                adicionarItem()
            }
        }
        isLoading = false
    }
    
    func adicionarItem() {
        print("adicionar item view model")
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
                case .failure(let err):
                    print(err.localizedDescription)
                    
            }
        }
    }
    
    //MARK: Métodos validadores
    func nomeValido(){
        if item.nome.isEmpty || item.nome == ""{
            mensagem = "Parece que você não colocou um nome neste item :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func categoriaValido(){
        if item.categoria.isEmpty || item.categoria == ""{
            mensagem = "Parece que você não selecionou uma categoria neste item :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func quantidadeValido(){
        if item.quantidade == 0{
            mensagem = "Parece que você colocou a quantidade neste item :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    func verificaCampos(){
        apresentaFeedback = false
        nomeValido()
        categoriaValido()
        quantidadeValido()
    }
    
    
}


extension FormItemViewModel {
    enum Modo {
        case novoItem
        case editarItem
    }
}
