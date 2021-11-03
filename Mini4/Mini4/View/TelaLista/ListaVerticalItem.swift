//
//  listaVerticalItem.swift
//  Mini4
//
//  Created by Gustavo Rigor on 20/10/21.
//

import SwiftUI

struct ListaVerticalItem: View {
    @EnvironmentObject var viewModel: EstoqueViewModel
//    @Binding var pesquisa: String
    var categoria: String = ""
    
    @ObservedObject var telaViewModel: TelaListaViewModel
    
    var body: some View {
        
        if !categoria.isEmpty{
            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: Categorias(rawValue: categoria) ?? .vazio, itemPesquisado: telaViewModel.itemPesquisado), titulo: Categorias(rawValue: categoria)?.titulo ?? "")
        }
        
        ForEach(telaViewModel.items.filter({($0.nome.contains(telaViewModel.itemPesquisado) || telaViewModel.itemPesquisado.isEmpty) && ($0.categoria == categoria || categoria.isEmpty) && $0.visivel && ($0.urgente || !telaViewModel.apenasUrgente) })){ item in
            ItemListaVerticalView(viewModel: .init(idOng: telaViewModel.idOng, idItem: item.id!))
                .frame(maxWidth: .infinity, minHeight: 55)
                .padding(.bottom, 10)
                .environmentObject(viewModel)
            
        }.padding(.horizontal, 30)
        .padding(.top, 10)
    }
}

