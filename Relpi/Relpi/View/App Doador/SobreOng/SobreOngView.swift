//
//  SobreOngView.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 07/10/21.
//

import SwiftUI

struct SobreOngView: View {
    @ObservedObject var viewModel: SobreOngViewModel
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 30) {
                
                //Nome e Cidade da ONG
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.nomeOng)
                        .textStyle(TitleStyle())
                    
                    Text(viewModel.cidade)
                        .textStyle(ContentStyle())
                }
                                
                // se tiver mais que dois itens, mostra só os dois primeiros itens
                if viewModel.itensEstocados() > 2 {
                    HStack {
                    ForEach(0..<2) { i in
                        ItemListaView(viewModel: .init(idOng: viewModel.idOng, item: viewModel.ong.estoque![i]), novaTela: $viewModel.trocaTela)
                            .frame(maxHeight: 220)
                    }
                    .padding(.horizontal, 30)
                    }
                    
                    Button(action: {}) {
                        NavigationLink(destination: TelaListaView(telaViewModel: .init(idOng: viewModel.idOng, data: viewModel.data)),
                                       label: {
                                        Text("Lista Completa")
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                       })
                    }
                    .buttonStyle(.primaryButton)
                } else {
                    if viewModel.itensEstocados() != 0 {
                        HStack {
                            ForEach(0..<viewModel.itensEstocados()) { i in
                                ItemListaView(viewModel: .init(idOng: viewModel.idOng, item: viewModel.ong.estoque![i]), novaTela: $viewModel.trocaTela)
                                    .frame(maxHeight: 220)
                            }
                            .padding(.horizontal, 30)
                        }
                        
                        // Listar todos os itens da ONG
                        Button(action: {}) {
                            NavigationLink(destination: TelaListaView(telaViewModel: .init(idOng: viewModel.idOng, data: viewModel.data)),
                                           label: {
                                            Text("Lista Completa")
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                           })
                        }
                        .buttonStyle(.primaryButton)
                        
                    } else {
                        DialogCard(text: "Esta ONG não precisa de nenhum item atualmente!", colorStyle: .green)
                    }
                    
                }
                                
                // Infos sobre a ONG
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sobre a ONG")
                        .textStyle(TitleStyle())
                    
                    if viewModel.image != nil {
                        Image(uiImage: viewModel.image!)
                            .resizable()
                            .cornerRadius(15)
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 30)
                    } else {
                        Image("ImagePlaceholder")
                            .resizable()
                            .cornerRadius(15)
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 30)
                    }


                    Text(viewModel.descricao)
                        .textStyle(ContentStyle())
                }
                
                // Contribuir com a ONG
                NavigationLink(destination: sobreOngDoadorView(viewModel: .init(idOng: viewModel.idOng, image: viewModel.image))) {
                    Text("Contribua")
                }.buttonStyle(PrimaryButton())
                
            }
            
        }
    }
}

