//
//  ListaGridItem.swift
//  Mini4
//
//  Created by Gustavo Rigor on 21/10/21.
//

import SwiftUI

struct ListaGridItem: View {

    var categoria: String = ""
    @State var fdc = false
    
    @ObservedObject var telaViewModel: TelaListaViewModel
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30), GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30)]
    
    var body: some View {
        
        if !categoria.isEmpty{
            TituloListaView(temItem: telaViewModel.temItemNaCategoria(categoria: Categorias(rawValue: categoria) ?? .vazio), titulo: Categorias(rawValue: categoria)?.titulo ?? "")
        }
        
        LazyVGrid(columns: gridItemLayout) {
            #if RelpiAdmin
            ForEach(telaViewModel.items.filter({ ($0.nome.contains(telaViewModel.itemPesquisado) || telaViewModel.itemPesquisado.isEmpty) && ($0.categoria == categoria || categoria.isEmpty) && ($0.urgente || !telaViewModel.apenasUrgente) })){ item in
                ItemListaView(viewModel: .init(idOng: telaViewModel.idOng, idItem: item.id!), novaTela: $fdc)
                    .frame(minWidth: 50, minHeight: 220)
                    .padding(.bottom, 10)
            }
            #else
            ForEach(telaViewModel.items.filter({ ($0.nome.contains(telaViewModel.itemPesquisado) || telaViewModel.itemPesquisado.isEmpty) && ($0.categoria == categoria || categoria.isEmpty) && $0.visivel && ($0.urgente || !telaViewModel.apenasUrgente) })){ item in
                ItemListaView(viewModel: .init(idOng: telaViewModel.idOng, idItem: item.id!), novaTela: $fdc)
                    .frame(minWidth: 50, minHeight: 220)
                    .padding(.bottom, 10)
            }
            #endif
        }.padding(.horizontal, 30)
        .padding(.top, 10)
    }
}
