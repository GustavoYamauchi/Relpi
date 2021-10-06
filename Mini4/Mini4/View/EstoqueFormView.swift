//
//  EstoqueFormView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 05/10/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct EstoqueFormView: View {
    @ObservedObject var viewModel: EstoqueViewModel
    
    var isEditing: Bool
    
    var body: some View {
        VStack{
            List{
                ForEach(viewModel.data){ item in
                    NavigationLink(
                        destination: ItemFormView(item: item, viewModel: viewModel, isEditing: isEditing),
                        label: {
                            Text(item.nome)
                        })
                }
            }
        }
    }
}

struct ItemFormView : View {
    @State var item: Item
    @ObservedObject var viewModel: EstoqueViewModel

    var isEditing: Bool
    
    var body: some View{
        VStack{
            TextField("nome", text: $item.nome).textFieldStyle(RoundedBorderTextFieldStyle())
            Text("Qtd: \(item.quantidade)")
            Text("Urgente:" + (item.urgente ? "Sim" : "Não"))
            Text("Visivel:" + (item.visivel ? "Sim" : "Não"))
            Button(action: {
               isEditing ? viewModel.updateItem(item: item) : viewModel.addItemData(item: item)
            }){
                Text(isEditing ? "Modificar" : "Criar")
            }
        }.onAppear{
            item = isEditing ? item : Item(nome: "", categoria: "", quantidade: 0, urgente: false, visivel: false)
        }
    }
}


