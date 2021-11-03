//
//  EditarItem.swift
//  Mini4Admin
//
//  Created by Gustavo Yamauchi on 18/10/21.
//

import Foundation
import SwiftUI

struct EditarLista: View {

    @State var item = Item(nome: "", categoria: "Medicamento", quantidade: 0, urgente: false, visivel: true)
    @EnvironmentObject var viewModel : EstoqueViewModel
    var body: some View {
        VStack{
            Image("\(item.categoria.lowercased())Icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .center)
                .padding(.top, 10)
            
            Spacer()
            
            VStack (alignment: .leading, spacing: 22){
                
                Text("Editar Item")
                    .padding(.leading, 30)
                    .padding(.top, 10)
                    .foregroundColor(Color.primaryButton)
                    .font(.system(size: 24, weight: .bold, design: .default))
                
                
                
                CustomTextField(text: $item.nome, placeholder: "Nome").padding(.horizontal, 30)
                    
                
                Category(array: ["Higiene","Alimento","Limpeza","Medicamento","Utensilio"], selected: $item.categoria)
                
                HStack{
                    Quantity(qtd: $item.quantidade)
                    
                    Spacer()
                    
                    Text("Urgente")
                        .foregroundColor(.textPlaceholderTextfield)
                        .lineLimit(1)
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .padding(.trailing, 10)
                    
                    Toggle("Agrupar Categorias", isOn: $item.urgente)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .destaque))
                    
//                    Toggle(isOn: $item.urgente, label: {
//                        Text("Urgente")
//                            .foregroundColor(.textPlaceholderTextfield)
//                            .lineLimit(1)
//                            .font(.system(size: 14, weight: .bold, design: .default))
////                            .padding(.leading, 80)
//                    })
//                    .toggleStyle(SwitchToggleStyle(tint: .destaque))
                    
                }.padding(.horizontal, 30)
                
                Button("Salvar", action: {
                    if item.id != nil {
                        viewModel.updateItem(item: item)
                    }
                    else {
                        if item.nome != "" {
                            viewModel.addItemData(item: item)
                        }
                        
                        
                    }
                    
                }).buttonStyle(.primaryButton)
                
                Button("Ocutar", action: {
                    item.visivel.toggle()
                    
                }).buttonStyle(.secondaryButton)
                
                Button("Excluir", action: {
                    if item.id != nil {
                        viewModel.deleteItem(item: item)
                    }
                }).buttonStyle(.deleteButton)
                
            }.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*3/5).background(Color.primaria).cornerRadius(30, corners: [.topLeft, .topRight])

        }.background(item.urgente ?
                        item.visivel ? Color.urgencia : Color.urgencia.opacity(0.5) :
                        item.visivel ? Color.regular: Color.regular.opacity(0.5))
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
