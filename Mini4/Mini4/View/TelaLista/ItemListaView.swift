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
        Text(item.nome)
    }
}

struct ItemListaView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListaView(item: Item(id: "", nome: "Vtnc", quantidade: 3, urgente: true, visivel: true))
    }
}
