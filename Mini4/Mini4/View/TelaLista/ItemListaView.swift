//
//  ItemListaView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 06/10/21.
//

import SwiftUI

struct ItemListaView: View {
    var item : Item
    @EnvironmentObject var estoqueViewModel: EstoqueViewModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(item.urgente ?
                                    item.visivel ? Color.urgencia : Color.urgencia.opacity(0.5) :
                                    item.visivel ? Color.regular : Color.urgencia.opacity(0.5))
            
            VStack(alignment: .center){
                NavigationLink(destination: EditarItem(item: item).environmentObject(estoqueViewModel),
                               label: {
                                VStack{
                                    Spacer()
                                    Image("\(item.categoria.lowercased())Icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150, height: 150, alignment: .center)
                                    Spacer()
                                    Text(item.nome)
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
//
//struct ItemListaView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemListaView(item: Item(id: "", nome: "", categoria: "", quantidade: 3, urgente: true, visivel: true))
//    }
//}
