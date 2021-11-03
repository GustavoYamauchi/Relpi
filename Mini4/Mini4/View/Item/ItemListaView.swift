//
//  ItemListaView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 06/10/21.
//

import SwiftUI

struct ItemListaView: View {
    @EnvironmentObject var estoqueViewModel: EstoqueViewModel
    
    @ObservedObject var viewModel: ItemViewModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(viewModel.item.urgente ?
                                    viewModel.item.visivel ? Color.urgencia : Color.urgencia.opacity(0.5) :
                                    viewModel.item.visivel ? Color.regular : Color.urgencia.opacity(0.5))
            
            VStack(alignment: .center){
                NavigationLink(destination: EditarItem(itemViewModel: .init(idOng: viewModel.idOng, idItem: viewModel.item.id!, modo: .editarItem)).environmentObject(estoqueViewModel),
                               label: {
                                VStack{
                                    Spacer()
                                    Image(viewModel.imagemNome)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150, height: 150, alignment: .center)
                                    Spacer()
                                    Text(viewModel.titulo)
                                        .font((.system(size: 20, weight: .regular, design: .rounded)))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.white)
                                        .padding(.bottom, 15)
                                        .padding(.horizontal, 10)
                                }
                                
                               })
               
            }
        }
    }
}
