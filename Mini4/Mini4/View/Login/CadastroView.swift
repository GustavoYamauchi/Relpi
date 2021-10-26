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
    @State var email: String = ""
    @State var senha: String = ""
    @State var confirmarSenha: String = ""
    @State var apresentarAlerta = false
    @State var mensagem: String = ""
    
    @EnvironmentObject var ongViewModel: OngViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State var showOngForm = false
    
    @State var novaOrganizacao = Organizacao(
        nome: "", cnpj: "", descricao: "", telefone: "", email: "",
        data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
        endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30){
            Image("logo_light")
                .frame(minWidth: 0, maxWidth: .infinity)
            
            Spacer(minLength: 0)
            
            Group {
                Text("Cadastre a sua ONG")
                    .padding(.top)
                    .foregroundColor(Color.primaria)
                    .font(.system(size: 24, weight: .bold, design: .default))
                
                CustomTextField(text: $email, placeholder: "E-mail")
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .padding(.horizontal, 30)
                
                CustomTextField(text: $senha, placeholder: "Senha", style: .password)
                    .padding(.horizontal, 30)
                
                CustomTextField(text: $confirmarSenha, placeholder: "Confirmar senha", style: .password)
                    .padding(.horizontal, 30)
                
                if apresentarAlerta {
                    DialogCard(text: mensagem, colorStyle: .red)
                }
                
                Button("Cadastrar") {
                    cadastrar()
                }.buttonStyle(.primaryButton)
                
                if showOngForm {
                    NavigationLink(destination: OngFormView(ong: $novaOrganizacao, isEditing: false)
                                    .environmentObject(ongViewModel), isActive: $showOngForm) {
                        EmptyView()
                    }
                }
            }
            
            Spacer(minLength: 0)
            
            VStack(alignment: .center, spacing: 10) {
                Text("Já possui uma conta?")
                
                Button(action: {}, label: {
                    NavigationLink(destination: LoginView().environmentObject(ongViewModel), label: { Text("Login") })
                }).buttonStyle(.textButton)
            }
            
        }
        .padding(.vertical, 50)
    }
    
    func cadastrar() {
        if senha == confirmarSenha {
            loginViewModel.cadastrar(email: email, senha: senha) { result in
                
                switch result {
                case .success:
                    novaOrganizacao.id = loginViewModel.id
                    showOngForm.toggle()
                    
                case .failure:
                    mensagem = loginViewModel.mensagem
                    apresentarAlerta.toggle()
                }
            }
            
        } else {
            mensagem = "As senhas não correspondem"
            apresentarAlerta.toggle()
        }
    }
}

