//
//  ListaGridItem.swift
//  Mini4
//
//  Created by Gustavo Rigor on 21/10/21.
//

import SwiftUI

struct ListaGridItem: View {
    @EnvironmentObject var viewModel: EstoqueViewModel
//    @Binding var pesquisa: String
    var categoria: String = ""
    
    @ObservedObject var telaViewModel: TelaListaViewModel
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30), GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30)]
    
    var body: some View {
        
        if !categoria.isEmpty{
            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: Categorias(rawValue: categoria) ?? .vazio, itemPesquisado: telaViewModel.itemPesquisado), titulo: Categorias(rawValue: categoria)?.titulo ?? "")
        }
        
        LazyVGrid(columns: gridItemLayout) {
            ForEach(telaViewModel.items.filter({ ($0.nome.contains(telaViewModel.itemPesquisado) || telaViewModel.itemPesquisado.isEmpty) && ($0.categoria == categoria || categoria.isEmpty) && $0.visivel && ($0.urgente || !viewModel.apenasUrgente) })){ item in
                ItemListaView(viewModel: .init(idOng: telaViewModel.idOng, idItem: item.id!))
                    .frame(minWidth: 50, minHeight: 220)
                    .padding(.bottom, 10)
                    .environmentObject(viewModel)
            }
        }.padding(.horizontal, 30)
        .padding(.top, 10)
    }
}
