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
                .foregroundColor(.sexternary)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            CustomTextField(text: $ong.nome, placeholder: "Nome da ONG")
            CustomTextField(text: $ong.cnpj, placeholder: "CNPJ")
            CustomTextField(text: $ong.descricao, placeholder: "Descrição da ONG", style: .multiline)
        }
    }
}
