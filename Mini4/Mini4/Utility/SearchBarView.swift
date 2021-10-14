//
//  SearchBarView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 13/10/21.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var pesquisando: String
    var placeholder : String = "Search"
    var body: some View {
        ZStack{
            HStack{
                TextField(placeholder, text: $pesquisando)
                    .padding()
                Spacer()
                if pesquisando.isEmpty{
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing, 20)
                        .accentColor(.searchBarIcon)
                } else {
                    Image(systemName: "xmark")
                        .padding(.trailing, 20)
                        .onTapGesture {
                            pesquisando = ""
                        }
                }
            }
            .background(RoundedRectangle(cornerRadius: 5).fill(Color.backgroundPrimarySearch))
            .cornerRadius(45)
        }.padding(.horizontal, 30)
//        .padding(.bottom, 10)
        
    }
}

struct SearchBarView_Previews: PreviewProvider {
    @State static var teste = ""
    static var previews: some View {
        SearchBarView(pesquisando: $teste)
    }
}
