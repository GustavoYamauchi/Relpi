//
//  EnderecoFormView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 04/10/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct EnderecoFormView: View {
    @ObservedObject var viewModel: EnderecoViewModel
    
    @State var endereco: Endereco = Endereco(logradouro: "", numero: "", complemento: "", bairro: "", cidade: "", cep: "", estado: "")
    
    var isEditing: Bool
    
    var body: some View {
        VStack {
            TextField("logradouro", text: $endereco.logradouro).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("numero", text: $endereco.numero).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("complemento", text: $endereco.complemento).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("bairro", text: $endereco.bairro).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("cidade", text: $endereco.cidade).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("cep", text: $endereco.cep).textFieldStyle(RoundedBorderTextFieldStyle())

        }.padding()

        Button(action: {
            if isEditing {
                viewModel.updateEndereco(endereco: endereco)
            } else {
                viewModel.addEnderecoData(endereco: endereco)
                self.endereco = Endereco(logradouro: "", numero: "", complemento: "", bairro: "", cidade: "", cep: "", estado: "")
            }
        }){
            Text("Add")
        }.padding()
        
        
        .onAppear {
            defineEndereco()
            endereco = (isEditing) ? endereco : Endereco(logradouro: "", numero: "", complemento: "", bairro: "", cidade: "", cep: "", estado: "")
        }
    }
    
    func defineEndereco(){
        if let primeiroEndereco = viewModel.data.first{
            endereco = primeiroEndereco
        }
    }
}
