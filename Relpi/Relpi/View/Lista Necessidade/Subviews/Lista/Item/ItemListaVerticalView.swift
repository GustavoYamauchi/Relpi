//
//  itemListaVerticalView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 14/10/21.
//

import SwiftUI

struct ItemListaVerticalView: View {
    @ObservedObject var viewModel: ItemViewModel
    @Binding var trocaDeTela: Bool
    
    // MARK: Subviews
    var itemView: some View {
        HStack(alignment: .center){
            Image(viewModel.imagemNome)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .center)
                .padding(.leading, 15)
            Text(viewModel.titulo)
                .font((.system(size: 20, weight: .regular, design: .rounded)))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white)
                .padding(.horizontal, 10)
            Spacer()
        }
    }
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(viewModel.item.urgente ?
                                    viewModel.item.visivel ? Color.urgencia : Color.urgencia.opacity(0.5) :
                                    viewModel.item.visivel ? Color.regular : Color.urgencia.opacity(0.5))
            #if Relpi
            itemView
            
            #else
            NavigationLink(destination: FormItem(itemViewModel: .init(idOng: viewModel.idOng, item: viewModel.item), novaTela: $trocaDeTela), label: {
                itemView
            })
            
            #endif
                
        }
        //.frame(height: 50)
    }
}

