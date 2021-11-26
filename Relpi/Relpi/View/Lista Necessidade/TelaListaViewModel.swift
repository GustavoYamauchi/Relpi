//
//  TelaListaViewModel.swift
//  Mini4
//
//  Created by Beatriz Sato on 03/11/21.
//

import SwiftUI
import Firebase

final class TelaListaViewModel: ObservableObject {
    private let estoqueService: EstoqueServiceProtocol
    let idOng: String
    
    var data: Timestamp
    var categorias = ["Limpeza", "Medicamento", "Higiene", "Utensilio", "Alimento"]
    
    @Published var listaCategorizada = false
    @Published var apenasUrgente = false
    @Published var mostrarFiltros = false
    @Published var listaVertical = true
    @Published var voltouTela = true
    @Published var itemPesquisado = ""
//    var categoria: String = ""
    
    @Published var items: [Item] = [Item]()
    
    // MARK: - Inicializador
    
    init(idOng: String, data: Timestamp, estoqueService: EstoqueServiceProtocol = EstoqueService()) {
        self.idOng = idOng
        self.estoqueService = estoqueService
        self.data = data
        
        addSnapshotListenerToItems()
    }
    
    
    // MARK: - Métodos
    
    var dataAtualizada: String {
        atualizaData()
        let date = Date(timeIntervalSince1970: TimeInterval(self.data.seconds))
        
        let formatador = DateFormatter()
        let formatadorHora = DateFormatter()
        formatador.dateStyle = .short
        formatadorHora.locale = .current
        formatador.locale = .current
        let template = "dd/MM/yyyy"
        let templateHora = "HH:mm"
        if let dateFormate = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: formatador.locale), let hourFormate = DateFormatter.dateFormat(fromTemplate: templateHora, options: 0, locale: formatador.locale){
            formatador.dateFormat = dateFormate
            formatadorHora.dateFormat = hourFormate
            return "Atualizado em \(formatador.string(from: date)) às \(formatadorHora.string(from: date))"
        }
        return "Parece que a Ong não teve atualizações"
    }
    
    func atualizaData(){
        estoqueService.getDate(idOng: idOng) { [weak self] result in
            switch result {
            case .success(let dataAtt):
                DispatchQueue.main.async {
                    self?.data = dataAtt
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchItems() {
        estoqueService.getItems(idOng: idOng) { [weak self] result in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    self?.items = items
                    self?.items.sort {$0.urgente && !$1.urgente}
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func temItemNaCategoria(categoria: Categorias) -> Bool{
        #if RelpiAdmin
        let filtro = items.filter({ ($0.nome.contains("\(itemPesquisado)") || itemPesquisado.isEmpty) && $0.categoria == categoria.rawValue  && ($0.urgente || !apenasUrgente)})
        #else
        let filtro = items.filter({ ($0.nome.contains("\(itemPesquisado)") || itemPesquisado.isEmpty) && $0.categoria == categoria.rawValue && $0.visivel  && ($0.urgente || !apenasUrgente)})
        #endif
        print("filtro: \(filtro.count) de \(filtro.first?.categoria ?? "")")
        return filtro.count > 0
    }
    
    func atualizar(){
        fetchItems()
    }
}

// MARK: - Snapshot Listener
extension TelaListaViewModel {
    
    private func addSnapshotListenerToItems() {
        let dbEstoque = Firestore.firestore().collection("ong").document(idOng).collection("estoque")
        
        dbEstoque.addSnapshotListener({ (snap_, err) in
            guard let snap = snap_ else {return}
            
            if let erro = err {
                print(erro.localizedDescription)
                return
            }
            
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
                    self.items.append(msgData)
                }
                if i.type == .modified{
                    for j in 0..<self.items.count{
                        if self.items[j].id == i.document.documentID{
                            self.items[j].nome = self.castString(i.document.get("nome"))
                            self.items[j].categoria = self.castString(i.document.get("categoria"))
                            self.items[j].quantidade = self.castInt(i.document.get("quantidade"))
                            self.items[j].urgente = self.castBool(i.document.get("urgente"))
                            self.items[j].visivel = self.castBool(i.document.get("visivel"))
                        }
                    }
                }
                if i.type == .removed{
                    self.items.remove(at: self.items.firstIndex(where: { item in
                        i.document.documentID == item.id
                    })!)
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
