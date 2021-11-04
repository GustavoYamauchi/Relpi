//
//  itemListaVerticalView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 14/10/21.
//

import SwiftUI

struct ItemListaVerticalView: View {
    @ObservedObject var viewModel: ItemViewModel
    @State var teste = false
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(viewModel.item.urgente ?
                                    viewModel.item.visivel ? Color.urgencia : Color.urgencia.opacity(0.5) :
                                    viewModel.item.visivel ? Color.regular : Color.urgencia.opacity(0.5))
            HStack(alignment: .center){
                NavigationLink(destination: EditarItem(itemViewModel: .init(idOng: viewModel.idOng, idItem: viewModel.item.id!, modo: .editarItem), novaTela: $teste), label: {
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
                })
                
            }
        }
        //.frame(height: 50)
    }
}

