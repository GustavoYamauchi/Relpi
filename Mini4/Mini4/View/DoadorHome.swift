//
//  DoadorHome.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI

struct DoadorHome: View {
    
    @ObservedObject var viewModel = OngViewModel()
    @State var search: String = ""
        
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            
            Image("logo_light")
            
            SearchBarView(pesquisando: $search, placeholder: "Search")
            
            Text("Explorar ONGs")
                .padding(.top)
                .foregroundColor(Color.sexternary)
                .font(.system(size: 24, weight: .bold, design: .default))
                .padding(.leading)
            
            ForEach(viewModel.data) { ong in
                HStack {
                    NavigationLink(destination: SobreOngView(ong: ong)) {
                        Text("\(ong.nome)")
                    }
                    .buttonStyle(SecondaryButton())
                }
            }
            
            Button("Ver todas") {
                print("ver todas")
            }.buttonStyle(.primaryButton)
            
            DialogCard(text: "Para favoritar ONGs e salvar itens na sua caixa de doação, faça login :)", colorStyle: .green)
            
            Button("Registrar") {
                print("registrar")
            }.buttonStyle(.textButton)
            
            //Falta chamar Tabbar
        }
    }
    
}

struct DoadorHome_Previews: PreviewProvider {
    static var previews: some View {
        DoadorHome()
    }
}
