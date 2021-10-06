//
//  FormInfoGeralView.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 04/10/21.
//

import SwiftUI

struct InfoGeralFormView: View {
    @Binding var ong: Organizacao
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Informações Gerais")
                .padding(.top)
                .foregroundColor(Color("primaryButton"))
                .font(.system(size: 24, weight: .bold, design: .default))
            
            TextField("Nome da Ong", text: $ong.nome).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("CNPJ", text: $ong.cnpj).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Descrição da ONG", text: $ong.descricao).textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
