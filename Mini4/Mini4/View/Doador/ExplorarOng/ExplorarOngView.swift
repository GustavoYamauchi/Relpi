//
//  ExplorarOngView.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 25/10/21.
//

import SwiftUI

struct ExplorarOngView: View {
    @ObservedObject var viewModel: ExplorarOngViewModel

    var headerView: some View {
        HStack {
            Image(viewModel.nomeImagemFiltro)
                .renderingMode(.template)
                .foregroundColor(viewModel.mostrarFiltros ? .primaryButton : .backgroundPrimarySearch)
                .frame(width: 40, height: 40, alignment: .center)
                .onTapGesture {
                    viewModel.mostrarFiltros = true
                }
            
            Spacer()
            Image(viewModel.nomeImagemColecao)
                .renderingMode(.template)
                .foregroundColor(!viewModel.listaVertical ? .primaryButton : .backgroundPrimarySearch)
                .frame(width: 40, height: 40, alignment: .center)
                .padding(.trailing, 20)
                .onTapGesture {
                    viewModel.listaVertical = false
                }
            
            Image(viewModel.nomeImagemTabela)
                .renderingMode(.template)
                .foregroundColor(viewModel.listaVertical ? .primaryButton : .backgroundPrimarySearch)
                .frame(width: 40, height: 40, alignment: .center)
                .onTapGesture {
                    viewModel.listaVertical = true
                }
        }.padding(.horizontal, 30)
        .padding(.vertical, 20)
    }
    
    //MARK: - View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
               headerView
                
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(viewModel.ongs) { ong in
                        if viewModel.listaVertical {
                            Button(action: {}) {
                                NavigationLink(destination: SobreOngView(viewModel: .init(ong: ong)),
                                               label: {
                                                Text(ong.nome)
                                                    .frame(minWidth: 0, maxWidth: .infinity)
                                               })
                            }
                            .buttonStyle(.secondaryButton)
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Button(action: {}) {
                                    NavigationLink(destination: SobreOngView(viewModel: .init(ong: ong)),
                                                   label: {
                                                    Text(ong.nome)
                                                        .textStyle(TitleStyle())
                                                   })
                                }
                                
                                if let id = ong.id {
                                    Image(uiImage: viewModel.getImage(from: id))
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
                                
                                Text(ong.endereco.cidade)
                                    .textStyle(ContentStyle())
                            }
                        }
                    }
                }
            }.sheet(isPresented: $viewModel.mostrarFiltros) {
                // TODO: Arrumar!!! deveria ser FiltroModal que nem TelaLista?
                Category(array: viewModel.array, selected: $viewModel.estadoSelecionado)
            }
            
        }
    }
}
