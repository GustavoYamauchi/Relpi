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
    
    var data: Timestamp
    
    var categorias = ["limpeza", "medicamento", "higiene", "utensilio", "alimento"]

    @State var itemPesquisado = ""
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            HStack{
                Image("filter")
                    .renderingMode(.template)
                    .foregroundColor(viewModel.listaCategorizada || viewModel.apenasUrgente ? .primaryButton : .backgroundPrimarySearch)
                    .frame(width: 40, height: 40, alignment: .center)
                    .onTapGesture {
                        viewModel.mostrarFiltros = true
                    }
                
                Spacer()
                Image("collection")
                    .renderingMode(.template)
                    .foregroundColor(!viewModel.listaVertical ? .primaryButton : .backgroundPrimarySearch)
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(.trailing, 20)
                    .onTapGesture {
                        viewModel.listaVertical = false
                    }
                
                Image("table")
                    .renderingMode(.template)
                    .foregroundColor(viewModel.listaVertical ? .primaryButton : .backgroundPrimarySearch)
                    .frame(width: 40, height: 40, alignment: .center)
                    .onTapGesture {
                        viewModel.listaVertical = true
                    }
                
            }.padding(.horizontal, 30)
            .padding(.vertical, 20)
            
            Text("Lista de necessidades")
                .padding(.top, 10)
                .padding(.leading, 25)
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Atualizado em \(converteData()).")
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
                    NavigationLink(destination: EditarLista().environmentObject(viewModel), label: {
                        Text("Adicionar itens na caixa de doação")
                    })
                })
                .buttonStyle(PrimaryButton())
                .padding(.vertical, 20)
                
        
                if viewModel.listaVertical{
                    if !viewModel.listaCategorizada{
                        ListaVerticalItem(pesquisa: $itemPesquisado)
                            .environmentObject(viewModel)
                    }else{
                        VStack(alignment: .leading){
                            ForEach(categorias, id: \.self){ categoria in
                                ListaVerticalItem(pesquisa: $itemPesquisado, categoria: categoria)
                                    .environmentObject(viewModel)
                            }
                        }
                    }
                }else{
                    if !viewModel.listaCategorizada{
                        ListaGridItem(pesquisa: $itemPesquisado)
                            .environmentObject(viewModel)
                    }else{
                        VStack(alignment: .leading){
                            ForEach(categorias, id: \.self){ categoria in
                                ListaGridItem(pesquisa: $itemPesquisado, categoria: categoria)
                                    .environmentObject(viewModel)
                            }
                        }
                        
                    }
                    
                }
            }
        }
        .onAppear{
            viewModel.data.sort {$0.urgente && !$1.urgente}
        }
        .sheet(isPresented: $viewModel.mostrarFiltros){
            FiltroModal(mostrarCategorias: $viewModel.listaCategorizada, mostrarApenasUrgentes: $viewModel.apenasUrgente, mostrandoView: $viewModel.mostrarFiltros)
        }
        
    }
    
    func converteData() -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(self.data.seconds))
        
        let formatador = DateFormatter()
        let formatadorHora = DateFormatter()
        formatador.dateStyle = .short
        formatadorHora.locale = .current
        formatador.locale = .current
        let template = "MM/dd/yyyy"
        let templateHora = "HH:mm"
        if let dateFormate = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: formatador.locale), let hourFormate = DateFormatter.dateFormat(fromTemplate: templateHora, options: 0, locale: formatador.locale){
            formatador.dateFormat = dateFormate
            formatadorHora.dateFormat = hourFormate
            return "\(formatador.string(from: date)) às \(formatadorHora.string(from: date))"
        }
        return ""
    }
}

