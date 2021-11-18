//
//  OrgView.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI
import Firebase

struct SobreOngViewGeral: View {
    
    let userService: UserServiceProtocol = UserService()
    @State var isOng = false
    @ObservedObject var viewModel: SobreOngGeralViewModel
    @State var itemPesquisado = ""
    
    // MARK: Subviews
    
    var tituloLabel: some View {
        Text((isOng) ? viewModel.bemVindoLabel : viewModel.nomeOngLabel)
            .padding(.top, 10)
            .padding(.leading, 25)
            .foregroundColor(Color.primaryButton)
            .font(.system(size: 24, weight: .bold, design: .default))
    }
    
    var nomeOngLabel: some View {
        Text((isOng) ? viewModel.nomeOngLabel : viewModel.cidadeOng)
            .padding(.leading, 25)
            .foregroundColor(Color.gray)
            .font(.system(size: 14, weight: .regular, design: .default))
            .padding(.bottom, 10)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                tituloLabel
                nomeOngLabel
                
                SearchBarView(pesquisando: $itemPesquisado, placeholder: "Pesquisar")
                    .padding(.vertical, 10)
                
                ScrollView{
                    HStack {
                        if viewModel.itensEstocados() > 0 {
                            let qtdItens = ((UIScreen.main.bounds.size.height > 1000) ? ((viewModel.itensEstocados() >= 3 ) ? 3 : 2): 2)
                            ForEach((viewModel.itensEstocados() >= qtdItens) ? 0..<qtdItens : 0..<1) { i in
                                if let id = viewModel.ongItens()[i].id {
                                    ItemListaView(viewModel: .init(idOng: viewModel.ong.id!, idItem: id), novaTela: ((isOng) ? $viewModel.voltouTela : $viewModel.trocaTela))
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
                        
                        if viewModel.selectedImage != nil {
                            Image(uiImage: viewModel.selectedImage!)
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

                        
                        Text(viewModel.ong.descricao)
                            .textStyle(ContentStyle())
                        
                    }.padding(.top, 20)
                    
                    // Contribuir com a ONG
                    
                    // TODO: Direcionar para a tela "Sobre ONG" certa!!! conferir o figma
                    #if RelpiAdmin
                    Button(action: {}, label: {
                        NavigationLink(destination: NewOngFormView(viewModel: .init(modo: .perfil, image: viewModel.selectedImage, ongHome: viewModel.ong, ongHomeViewModel: viewModel)),
                                       label: { Text(viewModel.verPerfilButtonLabel) } )
                    }).buttonStyle(.primaryButton)
                    .padding(.top, 20)
                    #else
                    NavigationLink(destination: sobreOngDoadorView(viewModel: .init(idOng: viewModel.ong.id!, image: viewModel.selectedImage))) {
                        Text("Contribua")
                    }.buttonStyle(PrimaryButton())
                    #endif
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .onChange(of: viewModel.voltouTela) { _ in
            viewModel.atualizar()
        }
        .navigationBarHidden(viewModel.isLoading)
        .navigationBarItems(trailing:
                                ZStack {
                                    #if RelpiAdmin
                                    NavigationLink(destination: CadastroView(viewModel: .init(mode: .login, usuario: .ong)), tag: 1, selection: $viewModel.tag){
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
                                    #else
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                        /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                                    })
                                    #endif
                                }
                        
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
    }
}
