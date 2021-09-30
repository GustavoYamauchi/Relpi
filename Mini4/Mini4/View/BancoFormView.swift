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
    @ObservedObject var viewModel = OngViewModel()
    
    @State var banco: Banco
    
    var isEditing: Bool
    
    var body: some View {
        VStack {
            TextField("nome do banco", text: $banco.banco).textFieldStyle(RoundedBorderTextFieldStyle())

        }.padding()

        Button(action: {
            if isEditing {
                //viewModel.updateOng(ong: banco)
            } else {
                //viewModel.addOrgData(org: banco)
                self.banco = Banco(banco: "")
            }
        }){
            Text("Add")
        }.padding()
        
        
        .onAppear {
            banco = (isEditing) ? banco : Banco(banco: "")
        }
    }
}
