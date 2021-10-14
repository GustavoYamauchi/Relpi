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
    @State var selectedItemTab = 0
    
    let tabItemNames = ["Home", "Favoritos", "CaixaDoacao"]
    var body: some View {
        VStack{
            ZStack{
                
                switch selectedItemTab {
                case 0:
                    VStack(alignment: .leading, spacing: 30){
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
                    }
                default:
                    VStack{
                        DialogCard(text: "Para favoritar ONGs e salvar itens na sua caixa de doação, faça login :)", colorStyle: .green)
                        
                        Button("Registrar") {
                            print("registrar")
                        }.buttonStyle(.textButton)
                    }
                }
                
            }
            
            Spacer()
            
            HStack{
                ForEach(0..<3){ num in
                    Button(action: {selectedItemTab = num}, label: {
                        Spacer()
                        Image(tabItemNames[num])
                            .padding(.vertical, 15)
                            .foregroundColor(selectedItemTab == num ? .textPrimaryButton : Color.textPrimaryButton.opacity(0.5))
                        Spacer()
                    })
                }
            }.background(Color.primaryButton).cornerRadius(50).padding(.horizontal,30)
        }
    }
    
}

struct DoadorHome_Previews: PreviewProvider {
    static var previews: some View {
        DoadorHome()
    }
}

