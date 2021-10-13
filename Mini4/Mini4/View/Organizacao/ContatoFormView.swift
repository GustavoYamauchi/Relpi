//
//  FormContatoView.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 04/10/21.
//

import SwiftUI

struct ContatoFormView: View {
    @Binding var ong: Organizacao
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Contato")
                .padding(.top)
                .foregroundColor(Color("primaryButton"))
                .font(.system(size: 24, weight: .bold, design: .default))
            
            TextField("Telefone", text: $ong.telefone).textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("E-mail", text: $ong.email).textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
