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
    
    @Binding var endereco: Endereco
    var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Endereço")
                .padding(.top)
                .foregroundColor(Color("primaryButton"))
                .font(.system(size: 24, weight: .bold, design: .default))
            
            CustomTextField(text: $endereco.cep, placeholder: "CEP")
            CustomTextField(text: $endereco.logradouro, placeholder: "Rua")
            CustomTextField(text: $endereco.numero, placeholder: "Numero e Complemento")
            CustomTextField(text: $endereco.estado, placeholder: "Estado")
            CustomTextField(text: $endereco.bairro, placeholder: "Bairro")
            CustomTextField(text: $endereco.cidade, placeholder: "Cidade")
        }
        .onAppear {
            endereco = (isEditing) ? endereco : Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: "")
        }
    }
    
}
