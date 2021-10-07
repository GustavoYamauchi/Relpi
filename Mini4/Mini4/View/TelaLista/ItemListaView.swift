//
//  ItemListaView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 06/10/21.
//

import SwiftUI

struct ItemListaView: View {
    var item : Item
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(item.urgente ?
                                    item.visivel ? Color.tertiary : Color.tertiary.opacity(0.5) :
                            item.visivel ? Color("quaternaryColor"): Color("tertiaryColor").opacity(0.5))
            VStack(alignment: .center){
                Spacer()
                Image("\(item.categoria)Icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150, alignment: .center)
                Spacer()
                Text(item.nome)
                    .font((.system(size: 20, weight: .regular, design: .rounded)))
                    .foregroundColor(Color.white)
                    .padding(.bottom, 15)
            }
        }
    }
}

struct ItemListaView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListaView(item: Item(id: "", nome: "Vtnc", categoria: "", quantidade: 3, urgente: true, visivel: true))
    }
}
