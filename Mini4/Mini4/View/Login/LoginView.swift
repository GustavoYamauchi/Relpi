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
            
            Spacer()
            
            Text("Entrar na sua ONG")
                .padding(.top)
                .foregroundColor(Color.primaria)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            CustomTextField(text: $email, placeholder: "E-mail")
                .autocapitalization(.none)
                .textContentType(.emailAddress)
            CustomTextField(text: $senha, placeholder: "Senha", style: .password)
            
            Button("Entrar") {
                login()
            }.buttonStyle(.primaryButton)
                        
            if showOngForm {
                NavigationLink(destination: OngHomeView(ong: ongViewModel.getOng(id: loginViewModel.id)), isActive: $showOngForm) {
                    EmptyView()
                }
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: 10) {
                Text("Ainda não possui conta?")

                Button(action: {}, label: {
                    NavigationLink(destination: CadastroView(), label: { Text("Cadastrar") })
                }).buttonStyle(.textButton)
                    
            }
            
        }.padding(.horizontal, 30)
        .padding(.vertical, 50)
        .alert(isPresented: $apresentarAlerta) {
            Alert(title: Text("Login"), message: Text(mensagem), dismissButton: Alert.Button.default(Text("OK")))
        }
    }
    
    func login() {
        loginViewModel.login(email: email, senha: senha)
        
        if loginViewModel.autenticado {
            showOngForm = true
        }
        
    }
}

