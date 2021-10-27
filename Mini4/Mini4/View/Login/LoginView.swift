//
//  LoginView.swift
//  Mini4
//
//  Created by Beatriz Sato on 18/10/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    @State var email: String = ""
    @State var senha: String = ""
    @State var apresentarAlerta = false
    @State var mensagem: String = ""
    
    @State var showOngForm = false
    @EnvironmentObject var ongViewModel: OngViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30){
            Image("logo_light")
                .frame(minWidth: 0, maxWidth: .infinity)
            
            Spacer()
            
            Group {
                Text("Entrar na sua ONG")
                    .padding(.top)
                    .foregroundColor(Color.primaria)
                    .font(.system(size: 24, weight: .bold, design: .default))
                
                CustomTextField(text: $email, placeholder: "E-mail")
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .padding(.horizontal, 30)
                CustomTextField(text: $senha, placeholder: "Senha", style: .password)
                    .padding(.horizontal, 30)
                
                if apresentarAlerta {
                    DialogCard(text: mensagem, colorStyle: .red)
                }
                
                Button("Entrar") {
                    login()
                }.buttonStyle(.primaryButton)
                            
                if showOngForm {
                    NavigationLink(destination: OngHomeView(ong: ongViewModel.getOng(id: loginViewModel.id)), isActive: $showOngForm) {
                        EmptyView()
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: 10) {
                Text("Ainda não possui conta?")

                Button(action: {}, label: {
                    NavigationLink(destination: CadastroView(viewModel: .init(mode: .cadastro, usuario: .ong)), label: { Text("Cadastrar") })
                }).buttonStyle(.textButton)
                    
            }
            
        }
        .padding(.vertical, 50)
    }
    
    func login() {
        loginViewModel.login(email: email, senha: senha) { result in
            switch result {
            case .success:
                showOngForm = true
            
            case .failure:
                mensagem = loginViewModel.mensagem
                apresentarAlerta.toggle()
            }
        }
    }
}

