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
    
    @State var showOngForm = false
    
    @State var novaOrganizacao = Organizacao(
        nome: "", cnpj: "", descricao: "", telefone: "", email: "",
        data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
        endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30){
            Image("logo_light")
            
            Spacer()
            
            Text("Cadastre a sua ONG")
                .padding(.top)
                .foregroundColor(Color.sexternary)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            CustomTextField(text: $email, placeholder: "E-mail")
                .autocapitalization(.none)
                .textContentType(.emailAddress)
            CustomTextField(text: $senha, placeholder: "Senha", style: .password)
            CustomTextField(text: $confirmarSenha, placeholder: "Confirmar senha", style: .password)
                        
            Button("Cadastrar") {
                cadastrar()
            }.buttonStyle(.primaryButton)
            
            NavigationLink(destination: OngFormView(ong: $novaOrganizacao, isEditing: false), isActive: $showOngForm) { EmptyView() }

            Spacer()
            
            VStack(alignment: .center, spacing: 10) {
                Text("Já possui uma conta?")

                Button(action: {}, label: {
                    NavigationLink(destination: LoginView(), label: { Text("Login") })
                }).buttonStyle(.textButton)
                    
            }
            
        }.padding(.horizontal, 30)
        .padding(.vertical, 50)
        .alert(isPresented: $apresentarAlerta) {
            Alert(title: Text("Cadastro"), message: Text(mensagem), dismissButton: Alert.Button.default(Text("OK")))
        }
    }
    
    func cadastrar() {
        if senha == confirmarSenha {
            Auth.auth().createUser(withEmail: email, password: senha) { [self] authResult, error in
                if let err = error {
                    mensagem = err.localizedDescription
                    apresentarAlerta.toggle()
                }
                
                if let authResult = authResult {
                    mensagem = "Cadastro feito com sucesso"
                    apresentarAlerta.toggle()
                    
                    let id = authResult.user.uid
                    
                    novaOrganizacao.id = id
                    
                    showOngForm.toggle()
                }
            }
        } else {
            mensagem = "As senhas não correspondem"
            apresentarAlerta.toggle()
        }
    }
}

