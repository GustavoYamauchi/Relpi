//
//  listaVerticalItem.swift
//  Mini4
//
//  Created by Gustavo Rigor on 20/10/21.
//

import SwiftUI

struct ListaVerticalItem: View {
    @EnvironmentObject var viewModel: EstoqueViewModel
    @Binding var pesquisa: String
    var categoria: String = ""
    var body: some View {
        
        if !categoria.isEmpty{
            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: Categorias(rawValue: categoria) ?? .vazio, itemPesquisado: pesquisa), titulo: Categorias(rawValue: categoria)?.titulo ?? "")
        }
        
        ForEach(viewModel.data.filter({($0.nome.contains(pesquisa) || pesquisa.isEmpty) && ($0.categoria == categoria || categoria.isEmpty) && $0.visivel})){ item in
            ItemListaVerticalView(item: item)
                .frame(maxWidth: .infinity, minHeight: 55)
                .padding(.bottom, 10)
            
        }.padding(.horizontal, 30)
        .padding(.top, 10)
    }
}

