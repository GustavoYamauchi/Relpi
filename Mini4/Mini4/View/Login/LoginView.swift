//
//  LoginView.swift
//  Mini4
//
//  Created by Beatriz Sato on 18/10/21.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State var email: String = ""
    @State var senha: String = ""
    @State var apresentarAlerta = false
    @State var mensagem: String = ""
    
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
        Auth.auth().signIn(withEmail: email, password: senha) { authResult, error in
            if let err = error {
                print(err.localizedDescription)
                apresentarAlerta.toggle()
                self.mensagem = err.localizedDescription
            } else {
                apresentarAlerta.toggle()
                self.mensagem = "Login feito com sucesso"
            }
        }
    }
}

