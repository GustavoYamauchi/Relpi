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
    
    @Binding var endereco: Endereco
    var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Endereço")
                .padding(.top)
                .font(.title)
            
            TextField("CEP", text: $endereco.cep).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Rua", text: $endereco.logradouro).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Numero", text: $endereco.numero).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Complemento", text: $endereco.complemento).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Bairro", text: $endereco.bairro).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Cidade", text: $endereco.cidade).textFieldStyle(RoundedBorderTextFieldStyle())

        }
        .onAppear {
//            defineEndereco()
            endereco = (isEditing) ? endereco : Endereco(logradouro: "", numero: "", complemento: "", bairro: "", cidade: "", cep: "", estado: "")
        }
    }
    
    func defineEndereco(){
        if let primeiroEndereco = viewModel.data.first{
            endereco = primeiroEndereco
        }
    }
}
