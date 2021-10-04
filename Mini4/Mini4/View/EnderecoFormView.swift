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
    
    @State var endereco: Endereco = Endereco(logradouro: "")
    
    var isEditing: Bool
    
    var body: some View {
        VStack {
            TextField("logradouro", text: $endereco.logradouro).textFieldStyle(RoundedBorderTextFieldStyle())

        }.padding()

        Button(action: {
            if isEditing {
                viewModel.updateEndereco(endereco: endereco)
            } else {
                viewModel.addEnderecoData(endereco: endereco)
                self.endereco = Endereco(logradouro: "")
            }
        }){
            Text("Add")
        }.padding()
        
        
        .onAppear {
            defineEndereco()
            endereco = (isEditing) ? endereco : Endereco(logradouro: "")
        }
    }
    
    func defineEndereco(){
        if let primeiroEndereco = viewModel.data.first{
            endereco = primeiroEndereco
        }
    }
}
