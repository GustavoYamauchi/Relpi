//
//  BancoFormView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 30/09/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct BancoFormView: View {
    @Binding var banco: Banco
    
    var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Dados Bancários")
                .padding(.top)
                .foregroundColor(Color("primaryButton"))
                .font(.system(size: 24, weight: .bold, design: .default))
            
            CustomTextField(text: $banco.banco, placeholder: "Nome do banco")
            CustomTextField(text: $banco.agencia, placeholder: "Agencia")
            CustomTextField(text: $banco.conta, placeholder: "Conta")
            CustomTextField(text: $banco.pix, placeholder: "Chave Pix")
        }
        .onAppear {
            banco = (isEditing) ? banco : Banco(banco: "", agencia: "", conta: "", pix: "")
        }
    }
}
