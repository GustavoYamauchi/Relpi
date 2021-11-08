//
//  CadastroView.swift
//  Mini4
//
//  Created by Beatriz Sato on 20/10/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct CadastroView: View {
    
    @ObservedObject var viewModel: LoginCadastroViewModel

    
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
        VStack(alignment: .leading, spacing: 30){
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
            
                NavigationLink(destination: NewOngFormView(viewModel: .init(modo: .cadastro)), isActive: $viewModel.encaminharOngForm) {
                    EmptyView()
                }
                
                if let id = viewModel.id {
                    NavigationLink(destination: OngHomeView(viewModel: .init(idOng: id)).environmentObject(EstoqueViewModel(id)) , isActive: $viewModel.encaminharOngHome) {
                        EmptyView()
                    }
                }
            }
            
            Spacer(minLength: 0)
            
            VStack(alignment: .center, spacing: 10) {
                Text(viewModel.temContaLabel)
                
                Button(action: {}, label: {
                    NavigationLink(destination:
                                    CadastroView(viewModel: .init(mode: (viewModel.mode == .cadastro) ? .login : .cadastro, usuario: .ong)),
                                   label: { Text(viewModel.temContaBotaoLabel) })
                }).buttonStyle(.textButton)
                                    
            }
            .padding(.vertical, 50)
        }
    }
}

