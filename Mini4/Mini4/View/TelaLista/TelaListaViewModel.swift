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
        
        fetchItems()
    }
    
    
    // MARK: - Métodos
    
    var dataAtualizada: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self.data.seconds))
        
        let formatador = DateFormatter()
        let formatadorHora = DateFormatter()
        formatador.dateStyle = .short
        formatadorHora.locale = .current
        formatador.locale = .current
        let template = "MM/dd/yyyy"
        let templateHora = "HH:mm"
        if let dateFormate = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: formatador.locale), let hourFormate = DateFormatter.dateFormat(fromTemplate: templateHora, options: 0, locale: formatador.locale){
            formatador.dateFormat = dateFormate
            formatadorHora.dateFormat = hourFormate
            return "\(formatador.string(from: date)) às \(formatadorHora.string(from: date))"
        }
        return ""
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
        let filtro = items.filter({ ($0.nome.contains("\(itemPesquisado)") || itemPesquisado.isEmpty) && $0.categoria == categoria.rawValue && $0.visivel  && ($0.urgente || !apenasUrgente)})
        print("filtro: \(filtro.count) de \(filtro.first?.categoria ?? "")")
        return filtro.count > 0
    }
    
    func atualizar(){
        fetchItems()
    }
}
