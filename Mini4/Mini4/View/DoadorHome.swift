//
//  DoadorHome.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI
import UIKit

struct DoadorHome: View {
    
    @ObservedObject var viewModel = OngViewModel()
    @State var pesquisa: String = ""
    @State var selectedItemTab = 0
    private var isLoggedIn = false
    private let rangeOng = 3
    
    let tabItemNames = ["Home", "Favoritos", "CaixaDoacao"]
    var body: some View {
        VStack {
            ZStack {
                switch selectedItemTab {
                case 0:
                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {
                            
                            Image("logo_light")
                                .frame(minWidth: 0, maxWidth: .infinity)
                            
                            SearchBarView(pesquisando: $pesquisa, placeholder: "Search")
                            
                            Text("Explorar ONGs")
                                .textStyle(TitleStyle())
                            
                            if pesquisa == "" {
                                if viewModel.data.count >= rangeOng { //verifica se tem 3 ongs e entrar no if
                                    ForEach(0..<3) { i in
                                        NavigationLink(destination: SobreOngView(ong: viewModel.data[i])) {
                                            Text("\(viewModel.data[i].nome)")
                                        }
                                        .buttonStyle(SecondaryButton())
                                    }
                                } else { // se tiver menos exibi só elas
                                    ForEach(viewModel.data) { ong in
                                        HStack {
                                            NavigationLink(destination: SobreOngView(ong: ong)) {
                                                Text("\(ong.nome)")
                                            }
                                            .buttonStyle(SecondaryButton())
                                        }
                                    }
                                }
                            } else {
                                ForEach(viewModel.data.filter({ $0.nome.contains(pesquisa) })) { ong in
                                    HStack {
                                        NavigationLink(destination: SobreOngView(ong: ong)) {
                                            Text("\(ong.nome)")
                                        }
                                        .buttonStyle(SecondaryButton())
                                    }
                                }
                                
                            }
                            
                            Button("Ver todas") {
                                print("ver todas")
                            }.buttonStyle(.primaryButton)
                        }
                    }
                case 1:
                    if isLoggedIn {
                        //TODO
                    } else {
                        VStack(alignment: .leading, spacing: 30) {
                            Spacer()
                            
                            DialogCard(text: "Para favoritar ONGs e salvar itens na sua caixa de doação, faça login :)", colorStyle: .green)
                            
                            Button("Registrar") {
                                print("registrar")
                            }.buttonStyle(.textButton)
                            
                            Spacer()
                        }
                    }
                default:
                    Text("Caixa de doacão")
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            
            Spacer()
            
            HStack {
                ForEach(0..<3) { num in
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

