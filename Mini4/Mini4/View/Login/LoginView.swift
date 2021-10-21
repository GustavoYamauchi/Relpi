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

    
    @State var ong: Organizacao
    
    init() {
        ong = Organizacao(
            nome: "", cnpj: "", descricao: "", telefone: "", email: "",
            data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
            endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
    }
        
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
                NavigationLink(destination: OngFormView(ong: $ong, isEditing: true).environmentObject(ongViewModel), isActive: $showOngForm) {
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
        Auth.auth().signIn(withEmail: email, password: senha) { authResult, error in
            if let err = error {
                print(err.localizedDescription)
                apresentarAlerta.toggle()
                self.mensagem = err.localizedDescription
                
            } else {
                
                let id = authResult?.user.uid
                if let ongBd = ongViewModel.data.first(where: { $0.id == id}) {
                    ong = ongBd
//
                    print(ong.nome)
                    print(ong.banco.banco)
//                    var enderecoViewModel = EnderecoViewModel(id!)
//                    var bancoViewModel = BancoViewModel(id!)
//                                    
//                    ong.endereco = enderecoViewModel.data.first ?? Endereco(logradouro: "1", numero: "", bairro: "", cidade: "", cep: "", estado: "")
//                    ong.banco = bancoViewModel.data.first ?? Banco(banco: "", agencia: "", conta: "", pix: "")
                } else {
                    ong.id = id
                }
                
                showOngForm.toggle()
                
            }
        }
    }
}

