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
    
//    @State var apresentarAlerta = false
    
    @EnvironmentObject var ongViewModel: OngViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State var showOngForm = false
    
    @State var novaOrganizacao = Organizacao(
        nome: "", cnpj: "", descricao: "", telefone: "", email: "",
        data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
        endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
    
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
                }
                
                if viewModel.apresentarAlerta {
                    DialogCard(text: viewModel.mensagem, colorStyle: .red)
                }
                
                Button(viewModel.botao) {
                    viewModel.botaoApertado()
                }.buttonStyle(.primaryButton)
            
                NavigationLink(destination: Text("Cadastrado") , isActive: $viewModel.encaminharOngForm) {
                    EmptyView()
                }
                
                NavigationLink(destination: Text("Logado") , isActive: $viewModel.encaminharOngHome) {
                    EmptyView()
                }
            }
            
            Spacer(minLength: 0)
            
            VStack(alignment: .center, spacing: 10) {
                Text(viewModel.rodape)
                
                Button(action: {}, label: {
                    NavigationLink(destination:
                                    CadastroView(viewModel: .init(mode: (viewModel.mode == .cadastro) ? .login : .cadastro, usuario: .ong))
                                    .environmentObject(ongViewModel),
                                   label: { Text(viewModel.botaoRodape) })
                }).buttonStyle(.textButton)
                                    
            }
            .padding(.vertical, 50)
        }
    }
}

