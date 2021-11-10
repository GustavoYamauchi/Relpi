//
//  TituloListaView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 15/10/21.
//

import SwiftUI


struct TituloListaView: View {
    var temItem : Bool
    var titulo : String
    var body: some View {
        if temItem{
            Text(titulo)
                .padding(.top, 10)
                .padding(.leading, 25)
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 24, weight: .bold, design: .default))
        }
    }
}

struct TituloListaView_Previews: PreviewProvider {
    static var previews: some View {
        TituloListaView(temItem: false, titulo: "Meme")
    }
}
