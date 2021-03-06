//
//  CadastroView.swift
//  Mini4
//
//  Created by Beatriz Sato on 20/10/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginCadastroView: View {
    
    @ObservedObject var viewModel: LoginCadastroViewModel
    
    @State var gestureIsValid = false
    
    // MARK: Gesture
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
    
    // MARK: Subviews
    var tituloView: some View {
        Text(viewModel.titulo)
            .padding(.top)
            .foregroundColor(Color("destaque"))
            .font(.system(size: 24, weight: .bold, design: .default))
            .padding(.horizontal, 30)
    }
    
    var emailTextField: some View {
        CustomTextField(text: $viewModel.email, placeholder: "E-mail")
            .autocapitalization(.none)
            .textContentType(.emailAddress)
            .padding(.horizontal, 30)
    }
    
    var senhaTextField: some View {
        CustomTextField(text: $viewModel.senha, placeholder: "Senha", style: .password)
            .padding(.horizontal, 30)
    }
    
    var confirmarSenhaTextField: some View {
        CustomTextField(text: $viewModel.confirmarSenha, placeholder: "Confirmar senha", style: .password)
            .padding(.horizontal, 30)
    }
    
    // MARK: View
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: geometry.size.height * 0.02){
                Image("logo_light")
                    .frame(minWidth: 0, maxWidth: .infinity)
                
                Spacer(minLength: 0)
                
                Group {
                    tituloView
                    emailTextField
                    senhaTextField
                    
                    if viewModel.mode == .cadastro {
                        confirmarSenhaTextField
                            .navigationBarBackButtonHidden(true)
                    }
                    
                    if viewModel.apresentarAlerta {
                        DialogCard(text: viewModel.mensagem, colorStyle: .red)
                    }
                    
                    Button(viewModel.botaoCadastrarEntrar) {
                        viewModel.cadastrarLogar()
                    }.buttonStyle(.primaryButton)
                    
                    NavigationLink(destination: OngFormView(viewModel: .init()), isActive: $viewModel.encaminharOngForm) {
                        EmptyView()
                    }
                    
                    if let id = viewModel.id {
                        NavigationLink(destination: SobreOngViewGeral(isOng:true, viewModel: .init(idOng: id, imagem: nil)), isActive: $viewModel.encaminharOngHome) {
                            EmptyView()
                        }
                    }
                }
                
                Spacer(minLength: 0)

                VStack(alignment: .center, spacing: 10) {
                    Text(viewModel.temContaLabel)

                    Button(action: {}, label: {
                        NavigationLink(destination:
                                        LoginCadastroView(viewModel: .init(mode: (viewModel.mode == .cadastro) ? .login : .cadastro, usuario: .ong)),
                                       label: {
                                        Text(viewModel.temContaBotaoLabel)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                       })
                    }).buttonStyle(.textButton)

                }
                .padding(.bottom, 50)
                .hidden()
                
            }
            .navigationBarHidden(true)
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .gesture(changePage)
    }
}
