//
//  listaVerticalItem.swift
//  Mini4
//
//  Created by Gustavo Rigor on 20/10/21.
//

import SwiftUI

struct ListaVerticalItem: View {

    var categoria: String = ""
    
    @ObservedObject var telaViewModel: TelaListaViewModel
    @Binding var trocaDeTela: Bool
    
    var body: some View {
        
        if !categoria.isEmpty{
            TituloListaView(temItem: telaViewModel.temItemNaCategoria(categoria: Categorias(rawValue: categoria) ?? .vazio), titulo: Categorias(rawValue: categoria)?.titulo ?? "")
        }
        #if RelpiAdmin
        ForEach(telaViewModel.items.filter({($0.nome.contains(telaViewModel.itemPesquisado) || telaViewModel.itemPesquisado.isEmpty) && ($0.categoria == categoria || categoria.isEmpty) && ($0.urgente || !telaViewModel.apenasUrgente) })){ item in
            ItemListaVerticalView(viewModel: .init(idOng: telaViewModel.idOng, item: item), trocaDeTela: $trocaDeTela)
                .frame(maxWidth: .infinity, minHeight: 55)
                .padding(.bottom, 10)
            
        }
        .padding(.horizontal, 30)
        .padding(.top, 10)
        #else
        ForEach(telaViewModel.items.filter({($0.nome.contains(telaViewModel.itemPesquisado) || telaViewModel.itemPesquisado.isEmpty) && ($0.categoria == categoria || categoria.isEmpty) && $0.visivel && ($0.urgente || !telaViewModel.apenasUrgente) })){ item in
            ItemListaVerticalView(viewModel: .init(idOng: telaViewModel.idOng, item: item), trocaDeTela: $trocaDeTela)
                .frame(maxWidth: .infinity, minHeight: 55)
                .padding(.bottom, 10)
            
        }
        .padding(.horizontal, 30)
        .padding(.top, 10)
        #endif
        
        
        
    }
}

