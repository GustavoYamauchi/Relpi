//
//  SobreOngView.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 07/10/21.
//

import SwiftUI

struct SobreOngView: View {
    
    @State private var ong: Organizacao
    @State private var selectedImage: UIImage?
    @State private var listaVertical = true
    @State private var listaCategorizada = false
    @State private var itemPesquisado = ""
    
    @ObservedObject var enderecoViewModel: EnderecoViewModel
    @ObservedObject var bancoViewModel: BancoViewModel
    @ObservedObject var estoqueViewModel: EstoqueViewModel
    
    
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30), GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30)]
    
    init(ong: Organizacao) {
        self.ong = ong
        self.enderecoViewModel = EnderecoViewModel(ong.id!)
        self.bancoViewModel = BancoViewModel(ong.id!)
        self.estoqueViewModel = EstoqueViewModel(ong.id!)
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 30) {
                
                HStack {
                    
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
                    
                }
                .padding(.horizontal, 30)
                
                //Nome e Cidade da ONG
                VStack(alignment: .leading, spacing: 8) {
                    Text(ong.nome)
                        .textStyle(TitleStyle())
                    
                    Text(ong.endereco.cidade)
                        .textStyle(ContentStyle())
                }
                
                SearchBarView(pesquisando: $itemPesquisado, placeholder: "Pesquisar Item")
                
                // Card dos itens
                HStack(spacing: 30) {
                    
                    if listaVertical {
                        
                        if listaCategorizada {
                            
                            ForEach(estoqueViewModel.data.filter({$0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty})){ item in
                                ItemListaVerticalView(item: item)
                                    .frame(maxWidth: .infinity, minHeight: 55)
                                    .padding(.bottom, 10)
                                
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                        } else {
                            
                            VStack(alignment: .leading) {
                                TituloListaView(temItem: estoqueViewModel.temItemNaCategoria(categoria: .limpeza, itemPesquisado: itemPesquisado), titulo: "Produto de limpeza")
                                
                                ForEach(estoqueViewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "limpeza" })){ item in
                                    ItemListaVerticalView(item: item)
                                        .frame(maxWidth: .infinity, minHeight: 55)
                                        .padding(.bottom, 10)
                                    
                                }.padding(.horizontal, 30)
                                .padding(.top, 10)
                                
                                TituloListaView(temItem: estoqueViewModel.temItemNaCategoria(categoria: .medicamento, itemPesquisado: itemPesquisado), titulo: "Medicamentos")
                                
                                ForEach(estoqueViewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "medicamento" })){ item in
                                    ItemListaVerticalView(item: item)
                                        .frame(maxWidth: .infinity, minHeight: 55)
                                        .padding(.bottom, 10)
                                    
                                }.padding(.horizontal, 30)
                                .padding(.top, 10)
                                
                                TituloListaView(temItem: estoqueViewModel.temItemNaCategoria(categoria: .higiene, itemPesquisado: itemPesquisado), titulo: "Higiene pessoal")
                                
                                ForEach(estoqueViewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "higiene" })){ item in
                                    ItemListaVerticalView(item: item)
                                        .frame(maxWidth: .infinity, minHeight: 55)
                                        .padding(.bottom, 10)
                                    
                                }.padding(.horizontal, 30)
                                .padding(.top, 10)
                                
                                TituloListaView(temItem: estoqueViewModel.temItemNaCategoria(categoria: .utensilio, itemPesquisado: itemPesquisado), titulo: "Utensílios de cozinha")
                                
                                ForEach(estoqueViewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "utensilio" })){ item in
                                    ItemListaVerticalView(item: item)
                                        .frame(maxWidth: .infinity, minHeight: 55)
                                        .padding(.bottom, 10)
                                    
                                }.padding(.horizontal, 30)
                                .padding(.top, 10)
                                
                                TituloListaView(temItem: estoqueViewModel.temItemNaCategoria(categoria: .alimento, itemPesquisado: itemPesquisado), titulo: "Alimento")
                                
                                ForEach(estoqueViewModel.data.filter( { ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "alimento" })){ item in
                                    ItemListaVerticalView(item: item)
                                        .frame(maxWidth: .infinity, minHeight: 55)
                                        .padding(.bottom, 10)
                                    
                                }.padding(.horizontal, 30)
                                .padding(.top, 10)
                            }
                        }
                    } else {
                        if listaCategorizada{
                            LazyVGrid(columns: gridItemLayout) {
                                ForEach(estoqueViewModel.data.filter({$0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty})){ item in
                                    ItemListaView(item: item)
                                        .frame(minWidth: 50, minHeight: 220)
                                        .padding(.bottom, 10)
                                }
                            }.padding(.horizontal, 30)
                            .padding(.top, 10)
                        } else {
                            VStack(alignment: .leading){
                                TituloListaView(temItem: estoqueViewModel.temItemNaCategoria(categoria: .limpeza, itemPesquisado: itemPesquisado), titulo: "Produto de limpeza")
                                
                                LazyVGrid(columns: gridItemLayout) {
                                    ForEach(estoqueViewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "limpeza" })){ item in
                                        ItemListaView(item: item)
                                            .frame(minWidth: 50, minHeight: 220)
                                            .padding(.bottom, 10)
                                    }
                                }.padding(.horizontal, 30)
                                .padding(.top, 10)
                                
                                TituloListaView(temItem: estoqueViewModel.temItemNaCategoria(categoria: .medicamento, itemPesquisado: itemPesquisado), titulo: "Medicamentos")
                                
                                LazyVGrid(columns: gridItemLayout) {
                                    ForEach(estoqueViewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "medicamento" })){ item in
                                        ItemListaView(item: item)
                                            .frame(minWidth: 50, minHeight: 220)
                                            .padding(.bottom, 10)
                                    }
                                }.padding(.horizontal, 30)
                                .padding(.top, 10)
                                
                                
                                TituloListaView(temItem: estoqueViewModel.temItemNaCategoria(categoria: .higiene, itemPesquisado: itemPesquisado), titulo: "Higiene pessoal")
                                
                                LazyVGrid(columns: gridItemLayout) {
                                    ForEach(estoqueViewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "higiene" })){ item in
                                        ItemListaView(item: item)
                                            .frame(minWidth: 50, minHeight: 220)
                                            .padding(.bottom, 10)
                                    }
                                }.padding(.horizontal, 30)
                                .padding(.top, 10)
                                
                                TituloListaView(temItem: estoqueViewModel.temItemNaCategoria(categoria: .utensilio, itemPesquisado: itemPesquisado), titulo: "Utensílios de cozinha")
                                
                                LazyVGrid(columns: gridItemLayout) {
                                    ForEach(estoqueViewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "utensilio" })){ item in
                                        ItemListaView(item: item)
                                            .frame(minWidth: 50, minHeight: 220)
                                            .padding(.bottom, 10)
                                    }
                                }.padding(.horizontal, 30)
                                .padding(.top, 10)
                                
                                TituloListaView(temItem: estoqueViewModel.temItemNaCategoria(categoria: .alimento, itemPesquisado: itemPesquisado), titulo: "Alimento")
                                
                                LazyVGrid(columns: gridItemLayout) {
                                    ForEach(estoqueViewModel.data.filter({ ($0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty) && $0.categoria == "alimento" })){ item in
                                        ItemListaView(item: item)
                                            .frame(minWidth: 50, minHeight: 220)
                                            .padding(.bottom, 10)
                                    }
                                }.padding(.horizontal, 30)
                                .padding(.top, 10)
                                
                            }
                            
                        }
                        
                    }
                    
//                    Image("ImagePlaceholder")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//
//                    Image("ImagePlaceholder")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
                }
                
                // Listar todos os itens da ONG
                Button("Lista completa") {
                    print("Lista completa")
                }.buttonStyle(.primaryButton)
                
                // Infos sobre a ONG
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sobre a ONG")
                        .textStyle(TitleStyle())
                    
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
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
                    
                    Text(ong.descricao)
                        .textStyle(ContentStyle())
                }
                
                // Contribuir com a ONG
                Button("Contribua") {
                    print("Contribua")
                }.buttonStyle(.primaryButton)
                
            }
            
        }.onAppear {
            getImage()
            if let banco = bancoViewModel.data.first,
               let enderecoVM = enderecoViewModel.data.first {
                self.ong.banco = banco
                self.ong.endereco = enderecoVM
            }
            
            self.ong.estoque = estoqueViewModel.data
        }
    }
    
    private func getImage() {
        if let foto = ong.foto {
            ImageStorageService.shared.downloadImage(urlString: foto) { image, err in
                DispatchQueue.main.async {
                    selectedImage = image
                }
            }
        }
    }
}

struct SobreOngView_Previews: PreviewProvider {
    @State static var ong = OngViewModel()
    
    static var previews: some View {
        SobreOngView(ong: ong.mockOngMariaHelena())
    }
}
