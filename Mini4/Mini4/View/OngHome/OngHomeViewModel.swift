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
    let estoqueService: EstoqueServiceProtocol
    
    @Published var ong: Organizacao
    @Published var selectedImage: UIImage
    @Published var voltouTela: Bool = false
    @Published var isLoading: Bool = true
    
    //MARK: - Elementos da View
    
    var bemVindoLabel: String {
        return "Bem-vindo!"
    }
    
    var nomeOngLabel: String {
        return ong.nome
    }
    
    var listaCompletaButtonLabel: String {
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
    
        
    //MARK: - Inicializador
    
    init(idOng: String,
         ongService: OngServiceProtocol = OngService(),
         estoqueService: EstoqueServiceProtocol = EstoqueService()
    ) {
        self.ongService = ongService
        self.estoqueService = estoqueService
        
        selectedImage = UIImage(named: "ImagePlaceholder") ?? UIImage(systemName: "camera")!
        
        self.ong = Organizacao(id: idOng, nome: "", cnpj: "", descricao: "", telefone: "", email: "", foto: "", data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""), endereco: Endereco( logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""), estoque: [Item]())
        
        fetchOng(idOng: idOng)
    }
    
    
    //MARK: - Métodos
    
    private func fetchOng(idOng: String) {
        isLoading = true
        ongService.getOng(idOng: idOng) { [weak self] result in
            switch result {
            case .success(let ong):
                self?.ong = ong
                self?.fetchImage()
                self?.fetchItems()
            case .failure(let err):
                print(err.localizedDescription)
            }
            self?.isLoading = false
        }
    }
    
    private func fetchImage() {
        isLoading = true
        if let foto = ong.foto {
            ImageStorageService.shared.downloadImage(urlString: foto) { [weak self] image, err in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.selectedImage = image
                    }
                }
            }
            self.isLoading = false
        }
    }
    
    private func fetchItems() {
        isLoading = true
        estoqueService.getItems(idOng: ong.id!) { result in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.ong.estoque = items
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isLoading = false
        }
    }
    
    func itensEstocados() -> Int {
        return ong.estoque?.count ?? 0
    }
    
    func item(at index: Int) -> Item {
        if let estoque = ong.estoque {
            return estoque[index]
        }
        return Item(id: "1", nome: "", categoria: "", quantidade: 0, urgente: false, visivel: false)
    }
    
    func ongItens() -> [Item] {
        if let estoque = ong.estoque {
            return estoque
        }
        return [Item]()
    }
    
    func atualizar(){
        fetchItems()
    }
}
