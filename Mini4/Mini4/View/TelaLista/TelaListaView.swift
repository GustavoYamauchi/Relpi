//
//  TelaListaView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 06/10/21.
//

import SwiftUI
import Firebase

struct TelaListaView: View {
    @EnvironmentObject var viewModel: EstoqueViewModel
    @ObservedObject var telaViewModel: TelaListaViewModel

    @State var itemPesquisado = ""
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            HStack{
                Image("filter")
                    .renderingMode(.template)
                    .foregroundColor(telaViewModel.listaCategorizada || telaViewModel.apenasUrgente ? .primaryButton : .backgroundPrimarySearch)
                    .frame(width: 40, height: 40, alignment: .center)
                    .onTapGesture {
                        telaViewModel.mostrarFiltros = true
                    }
                
                Spacer()
                Image("collection")
                    .renderingMode(.template)
                    .foregroundColor(!telaViewModel.listaVertical ? .primaryButton : .backgroundPrimarySearch)
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(.trailing, 20)
                    .onTapGesture {
                        telaViewModel.listaVertical = false
                    }
                
                Image("table")
                    .renderingMode(.template)
                    .foregroundColor(telaViewModel.listaVertical ? .primaryButton : .backgroundPrimarySearch)
                    .frame(width: 40, height: 40, alignment: .center)
                    .onTapGesture {
                        telaViewModel.listaVertical = true
                    }
                
            }.padding(.horizontal, 30)
            .padding(.vertical, 20)
            
            Text("Lista de necessidades")
                .padding(.top, 10)
                .padding(.leading, 25)
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Atualizado em \(telaViewModel.dataAtualizada).")
                .padding(.leading, 25)
                .foregroundColor(Color.gray)
                .font(.system(size: 14, weight: .regular, design: .default))
                .padding(.bottom, 10)
            
            SearchBarView(pesquisando: $itemPesquisado, placeholder: "Pesquisar")
                .padding(.vertical, 20)
            
            ScrollView{
            DialogCard(text: "Para realizar a doação, entre em contato com a ONG. Nossa plataforma apenas cataloga os itens demandados! :)", colorStyle: .yellow)
                .padding(.vertical, 20)
            
                
                
                Button(action: {}, label: {
                    NavigationLink(destination: EditarItem().environmentObject(viewModel), label: {
                        Text("Adicionar itens na caixa de doação")
                    })
                })
                .buttonStyle(PrimaryButton())
                .padding(.vertical, 20)
                
        
                if telaViewModel.listaVertical{
                    if !telaViewModel.listaCategorizada{
                        ListaVerticalItem(pesquisa: $itemPesquisado)
                            .environmentObject(viewModel)
                    }else{
                        VStack(alignment: .leading){
                            ForEach(telaViewModel.categorias, id: \.self){ categoria in
                                ListaVerticalItem(pesquisa: $itemPesquisado, categoria: categoria)
                                    .environmentObject(viewModel)
                            }
                        }
                    }
                }else{
                    if !telaViewModel.listaCategorizada{
                        ListaGridItem(pesquisa: $itemPesquisado)
                            .environmentObject(viewModel)
                    }else{
                        VStack(alignment: .leading){
                            ForEach(telaViewModel.categorias, id: \.self){ categoria in
                                ListaGridItem(pesquisa: $itemPesquisado, categoria: categoria)
                                    .environmentObject(viewModel)
                            }
                        }
                        
                    }
                    
                }
            }
        }
        .onAppear{
//            viewModel.items.sort {$0.urgente && !$1.urgente}
        }
        .sheet(isPresented: $telaViewModel.mostrarFiltros){
            FiltroModal(mostrarCategorias: $telaViewModel.listaCategorizada, mostrarApenasUrgentes: $telaViewModel.apenasUrgente, mostrandoView: $telaViewModel.mostrarFiltros)
        }
        
    }
}

