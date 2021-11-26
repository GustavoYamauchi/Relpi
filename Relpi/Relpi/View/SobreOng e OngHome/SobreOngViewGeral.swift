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
    @State var gestureIsValid = false
    
    // MARK: - Subviews
    
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
    
    // MARK: - Gesture
    var changePage : some Gesture{
        DragGesture()
            .onChanged { gesture in
                gestureIsValid = false
                if gesture.translation.height > 50{
                    gestureIsValid = true
                }
                
                if gesture.translation.height < -50{
                    gestureIsValid = true
                }
            }
            .onEnded({ _ in
                if gestureIsValid {
                  hideKeyboard()
                }
            })
    }
    
    // MARK: - View
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                tituloLabel
                nomeOngLabel
                
                SearchBarView(pesquisando: $viewModel.itemPesquisado, placeholder: "Pesquisar")
                    .padding(.vertical, 10)
                
                ScrollView{
                    HStack {
                        if viewModel.ongItens().count > 0 {
                            let qtdItens = ((UIScreen.main.bounds.size.height > 1000) ? ((viewModel.ongItens().count >= 3 ) ? 3 : 2): 2)

                            ForEach((viewModel.ongItens().count >= qtdItens) ? 0..<qtdItens : 0..<1) { i in
                                if viewModel.ongItens().count-1 >= i{
                                    ItemListaView(viewModel: .init(idOng: viewModel.ong.id!, item: viewModel.item(at: i)), novaTela: ((isOng) ? $viewModel.voltouTela : $viewModel.trocaTela))
                                        .frame(maxHeight: 220)
                                }
                                
                            }
                        }
                        
                    }.padding(.horizontal, 30)
                    
                    // TODO: MANDAR A ONG
                    if !isOng && viewModel.itensEstocados() == 0 {
                        DialogCard(text: "Essa ONG ainda não precisa de nenhum item! :)", colorStyle: .yellow)
                            .padding(.vertical, 20)
                    } else {
                        Button(action: {}) {
                            NavigationLink(destination: TelaListaView(telaViewModel: .init(idOng: viewModel.ong.id!, data: viewModel.ong.data)),
                                           label: {
                                            Text(viewModel.listaCompletaButtonLabel)
                                                .frame(minWidth: 0, maxWidth: .infinity)
                                           })
                        }
                        .buttonStyle(.primaryButton)
                    }
                    
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
                    
                    
                    // TODO: Direcionar para a tela "Sobre ONG" certa!!! conferir o figma
                    #if RelpiAdmin
                    Button(action: {}, label: {
                        NavigationLink(destination: OngFormView(viewModel: .init(ong: viewModel.ong, sobreOngViewModel: viewModel, image: viewModel.selectedImage)),
                                       label: {
                                        Text(viewModel.verPerfilButtonLabel)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                       } )
                    }).buttonStyle(.primaryButton)
                    .padding(.top, 20)
                    #else
                    // Contribuir com a ONG caso seja doador
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
        
        // MARK: - Modifiers
        .onChange(of: viewModel.voltouTela) { _ in
            viewModel.atualizar()
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .gesture(changePage)
        .navigationBarHidden(viewModel.isLoading)
        .navigationBarItems(trailing:
                                ZStack {
                                    #if RelpiAdmin
                                    NavigationLink(destination: LoginCadastroView(viewModel: .init(mode: .login, usuario: .ong)), tag: 1, selection: $viewModel.tag){
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
                                    #endif
                                }
                        
        )
        .navigationBarBackButtonHidden(isOng)
        .navigationBarTitle("", displayMode: .inline)
    }
}
