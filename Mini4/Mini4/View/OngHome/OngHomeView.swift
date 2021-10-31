//
//  OrgView.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI
import Firebase

struct OngHomeView: View {
    let userService: UserServiceProtocol = UserService()
    @ObservedObject var viewModel: OngHomeViewModel
    
    @EnvironmentObject var estoqueViewModel: EstoqueViewModel
    
    @State var itemPesquisado = ""
    @State var itens: [Item] = [Item(nome: "item0", categoria: "alimento", quantidade: 2, urgente: true, visivel: true), Item(nome: "item1", categoria: "alimento", quantidade: 2, urgente: false, visivel: true)]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Bem vindo!")
                .padding(.top, 10)
                .padding(.leading, 25)
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("\(viewModel.ong.nome)")
                .padding(.leading, 25)
                .foregroundColor(Color.gray)
                .font(.system(size: 14, weight: .regular, design: .default))
                .padding(.bottom, 10)
            
            SearchBarView(pesquisando: $itemPesquisado, placeholder: "Pesquisar")
                .padding(.vertical, 20)
            
            ScrollView{
                HStack {
                    ForEach(0..<2) { i in
                        ItemListaView(item: itens[i])
                            .frame(maxHeight: 220)
                            .environmentObject(estoqueViewModel)
                    }
                    .padding(.horizontal, 30)
                }
                
                if itens.count < 2{
                    Button(action: {}) {
                        NavigationLink(destination: TelaListaView(data: viewModel.ong.data).environmentObject(estoqueViewModel),
                                       label: { Text("Lista Completa") })
                    }
                    .buttonStyle(.primaryButton)
                }
                
                // Infos sobre a ONG
                VStack(alignment: .leading, spacing: 20) {
                    Text("Sobre a ONG")
                        .textStyle(TitleStyle())
                    
                    Image(uiImage: viewModel.selectedImage)
                        .resizable()
                        .cornerRadius(15)
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 30)
                    
                    Text(viewModel.ong.descricao)
                        .textStyle(ContentStyle())
                    
                }.padding(.top, 20)
                
                // Contribuir com a ONG

                // TODO: Direcionar para a tela "Sobre ONG" certa!!! conferir o figma
                
                Button(action: {}, label: {
                    NavigationLink(destination: NewOngFormView(viewModel: .init(modo: .perfil)),
                                   label: { Text("Ver Perfil") } )
                }).buttonStyle(.primaryButton)
                .padding(.top, 20)
            }
            
        }
        
        .navigationBarItems(trailing:  Button(action: { userService.logout() }, label: {
            Text("Logout")
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 16, weight: .bold, design: .default))
        }))
        
        .navigationBarTitle("", displayMode: .inline)
        
        
        .onChange(of: viewModel.ong, perform: { _ in
            populaItens()
        })
        
    }
    func populaItens(){
        if estoqueViewModel.data.count > 1{
            itens =  estoqueViewModel.data
        }
    }
}
