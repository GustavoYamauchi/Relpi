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
    @ObservedObject var viewModel: BancoViewModel
    
    @Binding var banco: Banco
    
    var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Dados Bancários")
                .padding(.top)
                .font(.title)
            
            TextField("nome do banco", text: $banco.banco).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("agencia", text: $banco.agencia).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("conta", text: $banco.conta).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("pix", text: $banco.pix).textFieldStyle(RoundedBorderTextFieldStyle())

        }
        
        .onAppear {
//            defineBanco()
            banco = (isEditing) ? banco : Banco(banco: "", agencia: "", conta: "", pix: "")
        }
    }
    
    func defineBanco(){
        if let primeiroBanco = viewModel.data.first{
            banco = primeiroBanco
        }
    }
}
