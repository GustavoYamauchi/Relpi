//
//  OngFormView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 28/09/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct OngFormView: View {
    @ObservedObject var viewModel = OngViewModel()
    
    @State var ong: Organizacao
    
    var isEditing: Bool
    
    var body: some View {
        VStack {
            TextField("nome", text: $ong.nome).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("cnpj", text: $ong.cnpj).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("descricao", text: $ong.descricao).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("telefone", text: $ong.telefone).textFieldStyle(RoundedBorderTextFieldStyle())
            
        }.padding()

        Button(action: {
            if isEditing {
                viewModel.updateOng(ong: ong)
            } else {
                viewModel.addOrgData(org: ong)
                self.ong = Organizacao(nome: "", cnpj: "", descricao: "", telefone: "")
            }
        }){
            Text("Add")
        }.padding()
        
        NavigationLink(
            destination: BancoFormView(viewModel: BancoViewModel(ong.id!), isEditing: false),
            label: {
                Text("Dados bancarios")
        })
            
        NavigationLink(
            destination: EnderecoFormView(viewModel: EnderecoViewModel(ong.id!), isEditing: true),
            label: {
                Text("Endereco")
            }).padding()
        
        .onAppear {
            ong = (isEditing) ? ong : Organizacao(nome: "", cnpj: "", descricao: "", telefone: "")
        }
    }
}
