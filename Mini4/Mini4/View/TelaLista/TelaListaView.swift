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
    var gridItemLayout = [GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30), GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30)]
    
    @State var listaVertical = true
    @State var listaCategorizada = false
    @State var itemPesquisado = ""
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            HStack{
                Image("filter")
                    .renderingMode(.template)
                    .foregroundColor(listaCategorizada ? .primaryButton : .backgroundPrimarySearch)
                    .frame(width: 40, height: 40, alignment: .center)
                    .onTapGesture {
                        listaCategorizada.toggle()
                    }
                
                Spacer()
                Image("collection")
                    .renderingMode(.template)
                    .foregroundColor(!listaVertical ? .primaryButton : .backgroundPrimarySearch)
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(.trailing, 20)
                    .onTapGesture {
                        listaVertical = false
                    }
                
                Image("table")
                    .renderingMode(.template)
                    .foregroundColor(listaVertical ? .primaryButton : .backgroundPrimarySearch)
                    .frame(width: 40, height: 40, alignment: .center)
                    .onTapGesture {
                        listaVertical = true
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
                
        
                if listaVertical{
                    if !listaCategorizada{
                        ForEach(viewModel.data.filter({$0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty})){ item in
                            ItemListaVerticalView(item: item)
                                .frame(maxWidth: .infinity, minHeight: 55)
                                .padding(.bottom, 10)
                            
                        }.padding(.horizontal, 30)
                        .padding(.top, 10)
                    }else{
                        
                        VStack(alignment: .leading){
                            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: .limpeza, itemPesquisado: itemPesquisado), titulo: "Produto de limpeza")
                            
                            ForEach(viewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "limpeza" })){ item in
                                ItemListaVerticalView(item: item)
                                    .frame(maxWidth: .infinity, minHeight: 55)
                                    .padding(.bottom, 10)
                                
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                            
                            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: .medicamento, itemPesquisado: itemPesquisado), titulo: "Medicamentos")
                            
                            ForEach(viewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "medicamento" })){ item in
                                ItemListaVerticalView(item: item)
                                    .frame(maxWidth: .infinity, minHeight: 55)
                                    .padding(.bottom, 10)
                                
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                            
                            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: .higiene, itemPesquisado: itemPesquisado), titulo: "Higiene pessoal")
                            
                            ForEach(viewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "higiene" })){ item in
                                ItemListaVerticalView(item: item)
                                    .frame(maxWidth: .infinity, minHeight: 55)
                                    .padding(.bottom, 10)
                                
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                            
                            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: .utensilio, itemPesquisado: itemPesquisado), titulo: "Utensílios de cozinha")
                            
                            ForEach(viewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "utensilio" })){ item in
                                ItemListaVerticalView(item: item)
                                    .frame(maxWidth: .infinity, minHeight: 55)
                                    .padding(.bottom, 10)
                                
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                            
                            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: .alimento, itemPesquisado: itemPesquisado), titulo: "Alimento")
                            
                            ForEach(viewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "alimento" })){ item in
                                ItemListaVerticalView(item: item)
                                    .frame(maxWidth: .infinity, minHeight: 55)
                                    .padding(.bottom, 10)
                                
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                        }
                        
                    }
                    
                }else{
                    if !listaCategorizada{
                        LazyVGrid(columns: gridItemLayout) {
                            ForEach(viewModel.data.filter({$0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty})){ item in
                                ItemListaView(item: item)
                                    .frame(minWidth: 50, minHeight: 220)
                                    .padding(.bottom, 10)
                            }
                        }.padding(.horizontal, 30)
                        .padding(.top, 10)
                    }else{
                        VStack(alignment: .leading){
                            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: .limpeza, itemPesquisado: itemPesquisado), titulo: "Produto de limpeza")
                            
                            LazyVGrid(columns: gridItemLayout) {
                                ForEach(viewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "limpeza" })){ item in
                                    ItemListaView(item: item)
                                        .frame(minWidth: 50, minHeight: 220)
                                        .padding(.bottom, 10)
                                }
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                            
                            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: .medicamento, itemPesquisado: itemPesquisado), titulo: "Medicamentos")
                            
                            LazyVGrid(columns: gridItemLayout) {
                                ForEach(viewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "medicamento" })){ item in
                                    ItemListaView(item: item)
                                        .frame(minWidth: 50, minHeight: 220)
                                        .padding(.bottom, 10)
                                }
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                            
                            
                            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: .higiene, itemPesquisado: itemPesquisado), titulo: "Higiene pessoal")
                            
                            LazyVGrid(columns: gridItemLayout) {
                                ForEach(viewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "higiene" })){ item in
                                    ItemListaView(item: item)
                                        .frame(minWidth: 50, minHeight: 220)
                                        .padding(.bottom, 10)
                                }
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                            
                            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: .utensilio, itemPesquisado: itemPesquisado), titulo: "Utensílios de cozinha")
                            
                            LazyVGrid(columns: gridItemLayout) {
                                ForEach(viewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "utensilio" })){ item in
                                    ItemListaView(item: item)
                                        .frame(minWidth: 50, minHeight: 220)
                                        .padding(.bottom, 10)
                                }
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                            
                            TituloListaView(temItem: viewModel.temItemNaCategoria(categoria: .alimento, itemPesquisado: itemPesquisado), titulo: "Alimento")
                            
                            LazyVGrid(columns: gridItemLayout) {
                                ForEach(viewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "alimento" })){ item in
                                    ItemListaView(item: item)
                                        .frame(minWidth: 50, minHeight: 220)
                                        .padding(.bottom, 10)
                                }
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                            
                        }
                        
                    }
                    
                }
            }
        }
        .onAppear{
            viewModel.data.sort {$0.urgente && !$1.urgente}
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

