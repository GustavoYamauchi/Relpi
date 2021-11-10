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
    @State var itemPesquisado = ""
    
    // MARK: Subviews
    
    var tituloLabel: some View {
        Text(viewModel.bemVindoLabel)
            .padding(.top, 10)
            .padding(.leading, 25)
            .foregroundColor(Color.primaryButton)
            .font(.system(size: 24, weight: .bold, design: .default))
    }
    
    var nomeOngLabel: some View {
        Text(viewModel.nomeOngLabel)
            .padding(.leading, 25)
            .foregroundColor(Color.gray)
            .font(.system(size: 14, weight: .regular, design: .default))
            .padding(.bottom, 10)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                //        VStack(){
                tituloLabel
                nomeOngLabel
                
                SearchBarView(pesquisando: $itemPesquisado, placeholder: "Pesquisar")
                    .padding(.vertical, 10)
                
                ScrollView{
                    HStack {
                        if viewModel.itensEstocados() > 0 {
                            ForEach((viewModel.itensEstocados() >= 2) ? 0..<2 : 0..<1) { i in
                                if let id = viewModel.ongItens()[i].id {
                                    ItemListaView(viewModel: .init(idOng: viewModel.ong.id!, idItem: id), novaTela: $viewModel.voltouTela)
                                        .frame(maxHeight: 220)
                                }
                            }
                        }
                        
                    }.padding(.horizontal, 30)
                    
                    Button(action: {}) {
                        NavigationLink(destination: TelaListaView(telaViewModel: .init(idOng: viewModel.ong.id!, data: viewModel.ong.data)),
                                       label: { Text(viewModel.listaCompletaButtonLabel) })
                    }
                    .buttonStyle(.primaryButton)
                    
                    // Infos sobre a ONG
                    VStack(alignment: .leading, spacing: 20) {
                        Text(viewModel.sobreOngLabel)
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
                                       label: { Text(viewModel.verPerfilButtonLabel) } )
                    }).buttonStyle(.primaryButton)
                    .padding(.top, 20)
                }
            }
        }
        .onChange(of: viewModel.voltouTela) { _ in
            viewModel.atualizar()
        }
        .navigationBarItems(trailing:
                                
                                ZStack {
                                    NavigationLink(destination: CadastroView(viewModel: .init(mode: .cadastro, usuario: .ong)), tag: 1, selection: $viewModel.tag){
                                        EmptyView()
                                    }
                                    
                                    Button(action: {
                                        userService.logout()
                                        //                print("Qual o problema dessa função?") O cara que está programando
                                        self.viewModel.tag = 1
                                    }, label: {
                                        Text(viewModel.logoutLabel)
                                            .foregroundColor(Color.primaryButton)
                                            .font(.system(size: 16, weight: .bold, design: .default))
                                    })
                                }
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        if viewModel.isLoading {
            LoadingView()
        }
    }
}
