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
    
    // MARK: - Propriedades
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
        addSnapshotListenerToItems()
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


// MARK: - Snapshot Listener
extension SobreOngGeralViewModel {
    
    private func addSnapshotListenerToItems() {
        let dbEstoque = Firestore.firestore().collection("ong").document(ong.id!).collection("estoque")
        
        dbEstoque.addSnapshotListener({ (snap_, err) in
            guard let snap = snap_ else {return}
            
            if let erro = err {
                print(erro.localizedDescription)
                return
            }
    
            if self.ong.estoque != nil{
                for i in snap.documentChanges{
                    if i.type == .added{
                        let msgData = Item(
                            id: i.document.documentID,
                            nome: self.castString(i.document.get("nome")),
                            categoria: self.castString(i.document.get("categoria")),
                            quantidade: self.castInt(i.document.get("quantidade")),
                            urgente: self.castBool(i.document.get("urgente")),
                            visivel: self.castBool(i.document.get("visivel"))
                        )
                        self.ong.estoque!.append(msgData)
                    }
                    if i.type == .modified{
                        for j in 0..<self.ong.estoque!.count{
                            if self.ong.estoque![j].id == i.document.documentID{
                                self.ong.estoque![j].nome = self.castString(i.document.get("nome"))
                                self.ong.estoque![j].categoria = self.castString(i.document.get("categoria"))
                                self.ong.estoque![j].quantidade = self.castInt(i.document.get("quantidade"))
                                self.ong.estoque![j].urgente = self.castBool(i.document.get("urgente"))
                                self.ong.estoque![j].visivel = self.castBool(i.document.get("visivel"))
                            }
                        }
                    }
                    if i.type == .removed{
                        self.ong.estoque!.remove(at: self.ong.estoque!.firstIndex(where: { item in
                            i.document.documentID == item.id
                        })!)
                    }
                }
            }
        })
    }
    
    func castString(_ variable: Any?) -> String{
        if let str = variable as? String{
            return str
        }
        return ""
    }
    
    func castInt(_ variable: Any?) -> Int{
        if let int = variable as? Int{
            return int
        }
        return 0
    }
    
    func castBool(_ variable: Any?) -> Bool{
        if let bool = variable as? Bool{
            return bool
        }
        return false
    }
}
