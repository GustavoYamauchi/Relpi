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

final class SobreOngGeralViewModel: ObservableObject {
    
    let ongService: OngServiceProtocol
    let estoqueService: EstoqueServiceProtocol
    
    @Published var ong: Organizacao
    @Published var selectedImage: UIImage?
    @Published var voltouTela: Bool = false
    @Published var trocaTela: Bool = false
    @Published var tag:Int? = nil
    @Published var isLoading = false
    @Published var itemPesquisado = ""
    
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
    
    var cidadeOng: String{
        return ong.endereco.cidade
    }
    
        
    //MARK: - Inicializador
    
    init(idOng: String,
         ongService: OngServiceProtocol = OngService(),
         estoqueService: EstoqueServiceProtocol = EstoqueService(), imagem:UIImage?
    ) {
        self.ongService = ongService
        self.estoqueService = estoqueService
        
        self.ong = Organizacao(id: idOng, nome: "", cnpj: "", descricao: "", telefone: "", email: "", site: "", foto: "", data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""), endereco: Endereco( logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""), estoque: [Item]())
        
        self.selectedImage = imagem
        
        fetchOng(idOng: idOng)
    }
    
    // inicializador ONG
        // vai carregar a ong a partir do id
    
    // inicializador doador
        // tem ong carregada já mas sem imagem
    
    
    //MARK: - Métodos
    
    private func fetchOng(idOng: String) {
        isLoading = true
        ongService.getOng(idOng: idOng) { [weak self] result in
            switch result {
            case .success(let ong):
                self?.ong = ong
                self?.fetchImage()
                self?.fetchItems()
                self?.isLoading = false
            case .failure(let err):
                self?.isLoading = false
                print(err.localizedDescription)
            }
            self?.isLoading = false
        }
    }
    
    private func fetchOngSemImagem(idOng: String) {
        ongService.getOng(idOng: idOng) { [weak self] result in
            self?.isLoading = true
            switch result {
            case .success(let ong):
                self?.ong = ong
                self?.fetchItems()
                self?.isLoading = false
            case .failure(let err):
                self?.isLoading = false
                print(err.localizedDescription)
            }
        }
    }
    
    private func fetchImage() {
        if let foto = ong.foto {
            self.isLoading = true
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
        estoqueService.getItems(idOng: ong.id!) { result in
            self.isLoading = true
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.ong.estoque = items
                    self.isLoading = false
                }
            case .failure(let error):
                self.isLoading = false
                print(error.localizedDescription)
            }
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
            return estoque.filter({($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty)})
        }
        return [Item]()
    }
    
    func ongItens(_ qtd:Int) -> [Item] {
        if let estoque = ong.estoque {
            let validItens = estoque.filter({($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty)})
            var itens = [Item]()
            if qtd >= validItens.count{
                for num in 0...qtd-1{
                    print(num)
                    itens.append(validItens[num])
                }
                return itens
            }
        }
        return [Item]()
    }
    
    func atualizar(){
        fetchItems()
    }
}

extension SobreOngGeralViewModel: OngFormViewModelDelegate {
    func atualizarHome() {
        fetchOngSemImagem(idOng: ong.id!)
    }
    
    func atualizarHomeComImagem() {
        fetchOng(idOng: ong.id!)
    }
}
