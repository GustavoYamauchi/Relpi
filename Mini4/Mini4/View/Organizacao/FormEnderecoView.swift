//
//  FormEnderecoView.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 04/10/21.
//

import SwiftUI

struct FormEnderecoView: View {
    @State var endereco: Endereco
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Endereço")
                .padding(.top)
                .font(.title)
            
            TextField("Rua", text: $endereco.logradouro).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Número e complemento", text: $endereco.numero).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Bairro", text: $endereco.bairro).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("CEP", text: $endereco.cep).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Cidade", text: $endereco.cidade).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Estado", text: $endereco.estado).textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
//struct FormEnderecoView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormEnderecoView()
//    }
//}
