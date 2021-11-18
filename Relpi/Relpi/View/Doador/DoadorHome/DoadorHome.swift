//
//  DoadorHome.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI
import UIKit

struct DoadorHome: View {
    
    @ObservedObject var doadorViewModel: DoadorHomeViewModel
    
    @State var pesquisa: String = ""
    @State var selectedItemTab = 0
    
    let tabItemNames = ["Home", "Favoritos", "CaixaDoacao"]
    
    var body: some View {
        VStack {
            ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        Image(doadorViewModel.nomeImagemLogo)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        
                        SearchBarView(pesquisando: $pesquisa, placeholder: doadorViewModel.searchBarPlaceholder)
                        
                        Text(doadorViewModel.explorarOngLabel)
                            .textStyle(TitleStyle())
                        let qtdItensPorTamanhoTela = Int((UIScreen.main.bounds.size.height * 0.25 / 41.61) - 1)
                        if pesquisa == "" {
                            if doadorViewModel.quantidadeOngs() >= doadorViewModel.rangeOng { //verifica se tem 3 ongs e entrar no if
                                ForEach(0..<qtdItensPorTamanhoTela) { i in
//                                    NavigationLink(destination: SobreOngViewGeral(viewModel: .init(ong: doadorViewModel.ong(at: i), imagem: nil))) {
//                                        Text(doadorViewModel.ongName(at: i))
//                                    }
                                    NavigationLink(destination: SobreOngViewGeral(viewModel: .init(idOng: doadorViewModel.ong(at: i).id!))) {
                                        Text(doadorViewModel.ongName(at: i))
                                    }
                                    .buttonStyle(SecondaryButton())
                                }
                            } else { // se tiver menos exibi só elas
                                ForEach(doadorViewModel.ongs) { ong in
                                    HStack {
                                        NavigationLink(destination: SobreOngViewGeral(viewModel: .init(idOng: ong.id!))) {
                                            Text("\(ong.nome)")
                                        }
                                        .buttonStyle(SecondaryButton())
                                    }
                                }
                            }
                        } else {
                            ForEach(doadorViewModel.ongs.filter({ $0.nome.contains(pesquisa) })) { ong in
                                HStack {
                                    NavigationLink(destination: SobreOngView(viewModel: .init(ong:ong, imagem: nil))) {
                                        Text("\(ong.nome)")
                                    }
                                    .buttonStyle(SecondaryButton())
                                }
                            }
                        }
                        
                        Button(action: {}) {
                            NavigationLink(destination: ExplorarOngView(viewModel: .init(ongs: doadorViewModel.ongs)),
                                           label: {
                                            Text(doadorViewModel.botaoTodasOngs)
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                           })
                        }
                        .buttonStyle(.primaryButton)
                    }
                }
            }
        }

//MARK: Codigo pra utilizar quando tiver a tela de caixa de doação e/ou ONGs favoritas
//        VStack {
//            ZStack {
//                switch selectedItemTab {
//                case 0:
//                    ScrollView {
//                        VStack(alignment: .leading, spacing: 30) {
//
//                            Image(doadorViewModel.nomeImagemLogo)
//                                .frame(minWidth: 0, maxWidth: .infinity)
//
//                            SearchBarView(pesquisando: $pesquisa, placeholder: doadorViewModel.searchBarPlaceholder)
//
//                            Text(doadorViewModel.explorarOngLabel)
//                                .textStyle(TitleStyle())
//
//                            if pesquisa == "" {
//                                if doadorViewModel.quantidadeOngs() >= doadorViewModel.rangeOng { //verifica se tem 3 ongs e entrar no if
//                                    ForEach(0..<3) { i in
//                                        NavigationLink(destination: SobreOngView(viewModel: .init(ong: doadorViewModel.ong(at: i), imagem: nil))) {
//                                            Text(doadorViewModel.ongName(at: i))
//                                        }
//                                        .buttonStyle(SecondaryButton())
//                                    }
//                                } else { // se tiver menos exibi só elas
//                                    ForEach(doadorViewModel.ongs) { ong in
//                                        HStack {
//                                            NavigationLink(destination: SobreOngView(viewModel: .init(ong: ong, imagem: nil))) {
//                                                Text("\(ong.nome)")
//                                            }
//                                            .buttonStyle(SecondaryButton())
//                                        }
//                                    }
//                                }
//                            } else {
//                                ForEach(doadorViewModel.ongs.filter({ $0.nome.contains(pesquisa) })) { ong in
//                                    HStack {
//                                        NavigationLink(destination: SobreOngView(viewModel: .init(ong:ong, imagem: nil))) {
//                                            Text("\(ong.nome)")
//                                        }
//                                        .buttonStyle(SecondaryButton())
//                                    }
//                                }
//                            }
//
//                            Button(action: {}) {
//                                NavigationLink(destination: ExplorarOngView(viewModel: .init(ongs: doadorViewModel.ongs)),
//                                               label: {
//                                                Text(doadorViewModel.botaoTodasOngs)
//                                                    .frame(minWidth: 0, maxWidth: .infinity)
//                                               })
//                            }
//                            .buttonStyle(.primaryButton)
//                        }
//                    }
//
//                case 1:
//                    if doadorViewModel.isLoggedIn {
//                        //TODO
//                    } else {
//                        VStack(alignment: .leading, spacing: 30) {
//                            Spacer()
//
//                            DialogCard(text: doadorViewModel.mensagemLogin, colorStyle: .green)
//
//                            Button("Registrar") {
//                                print("registrar")
//                            }.buttonStyle(.textButton)
//
//                            Spacer()
//                        }
//                    }
//                default:
//                    Text("Caixa de doação")
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                }
//            }
//
//            Spacer()
//
//            HStack {
//                ForEach(0..<3) { num in
//                    Button(action: {selectedItemTab = num}, label: {
//                        Spacer()
//                        Image(tabItemNames[num])
//                            .padding(.vertical, 15)
//                            .foregroundColor(selectedItemTab == num ? .textPrimaryButton : Color.textPrimaryButton.opacity(0.5))
//                        Spacer()
//                    })
//                }
//            }.background(Color.primaryButton).cornerRadius(50).padding(.horizontal,30)
//        }
//    }
    
}


