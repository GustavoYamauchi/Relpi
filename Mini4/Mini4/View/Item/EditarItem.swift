//
//  EditarItem.swift
//  Mini4Admin
//
//  Created by Gustavo Yamauchi on 18/10/21.
//

import Foundation
import SwiftUI

struct EditarItem: View {

    @EnvironmentObject var viewModel : EstoqueViewModel
    
    @ObservedObject var itemViewModel: FormItemViewModel
    
    var body: some View {
        VStack{
            Image(itemViewModel.imagemNome)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .center)
                .padding(.top, 10)
            
            Spacer()
            
            VStack (alignment: .leading, spacing: 22){
                
                Text(itemViewModel.titulo)
                    .padding(.leading, 30)
                    .padding(.top, 10)
                    .foregroundColor(Color.primaryButton)
                    .font(.system(size: 24, weight: .bold, design: .default))
                                
                CustomTextField(text: $itemViewModel.item.nome, placeholder: "Nome").padding(.horizontal, 30)
                    
                Category(array: ["Higiene","Alimento","Limpeza","Medicamento","Utensilio"], selected: $itemViewModel.item.categoria)
                
                HStack{
                    Quantity(qtd: $itemViewModel.item.quantidade)
                    
                    Spacer()
                    
                    Toggle(isOn: $itemViewModel.item.urgente, label: {
                        Text("Urgente")
                            .foregroundColor(.textPlaceholderTextfield)
                            .font(.system(size: 14, weight: .bold, design: .default))
                            .padding(.leading, 80)
                    })
                    .toggleStyle(SwitchToggleStyle(tint: .destaque))
                    
                }.padding(.horizontal, 30)
                
                Button("Salvar", action: {
                    if itemViewModel.item.id != nil {
                        viewModel.updateItem(item: itemViewModel.item)
                    }
                    else {
                        if itemViewModel.item.nome != "" {
                            viewModel.addItemData(item: itemViewModel.item)
                        }
                        
                        
                    }
                    
                }).buttonStyle(.primaryButton)
                
                Button("Ocutar", action: {
                    itemViewModel.item.visivel.toggle()
                    
                }).buttonStyle(.secondaryButton)
                
                Button("Excluir", action: {
                    if itemViewModel.item.id != nil {
                        viewModel.deleteItem(item: itemViewModel.item)
                    }
                }).buttonStyle(.deleteButton)
                
            }.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height*3/5).background(Color.primaria).cornerRadius(30, corners: [.topLeft, .topRight])

        }.background(itemViewModel.item.urgente ?
                        itemViewModel.item.visivel ? Color.urgencia : Color.urgencia.opacity(0.5) :
                        itemViewModel.item.visivel ? Color.regular: Color.regular.opacity(0.5))
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
