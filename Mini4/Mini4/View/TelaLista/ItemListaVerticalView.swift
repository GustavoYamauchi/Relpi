//
//  itemListaVerticalView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 14/10/21.
//

import SwiftUI

struct ItemListaVerticalView: View {
    var item : Item
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(item.urgente ?
                                    item.visivel ? Color.tertiary : Color.tertiary.opacity(0.5) :
                            item.visivel ? Color("quaternaryColor"): Color("tertiaryColor").opacity(0.5))
            HStack(alignment: .center){
                Image("\(item.categoria)Icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(.leading, 15)
                Text(item.nome)
                    .font((.system(size: 20, weight: .regular, design: .rounded)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 10)
                Spacer()
            }
        }
    }
}

struct itemListaVerticalView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListaVerticalView(item: Item(id: "", nome: "Vtnc", categoria: "", quantidade: 3, urgente: true, visivel: true))
    }
}