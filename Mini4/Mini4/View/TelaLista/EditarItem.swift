//
//  EditarItem.swift
//  Mini4Admin
//
//  Created by Gustavo Yamauchi on 18/10/21.
//

import Foundation
import SwiftUI

struct EditarLista: View {

    @State var item = Item(nome: "Item", categoria: "medicamento", quantidade: 10, urgente: false, visivel: true)
    @EnvironmentObject var viewModel : EstoqueViewModel
    var body: some View {
        VStack{
            
            
            Image("\(item.categoria)Icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .center)
            
            Spacer()
            
            VStack (alignment: .leading){
                
                CustomTextField(text: $item.nome, placeholder: "Nome").padding(.horizontal, 30)
                    
                
                Category(array: ["higiene","alimento","limpeza","medicamento","utensilio"], selected: $item.categoria)
                
                HStack{
                    Quantity(qtd: $item.quantidade)
                    
                    Spacer()
                    
                    Toggle(isOn: $item.urgente, label: {
                        Text("urgente")
                            .foregroundColor(.sexternary)
                            .font(.system(size: 24, weight: .bold, design: .default))
                    })
                    .toggleStyle(SwitchToggleStyle(tint: .sexternary))
                    .padding(.leading, 50)
                }.padding(30)
                
                Button("Salvar", action: {
                    if item.id != nil {
                        viewModel.updateItem(item: item)
                    }
                    else {
                        viewModel.addItemData(item: item)
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
                
            }.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2).background(Color.primary).cornerRadius(30, corners: [.topLeft, .topRight])

        }.background(item.urgente ?
                        item.visivel ? Color.tertiary : Color.tertiary.opacity(0.5) :
                item.visivel ? Color("quaternaryColor"): Color("tertiaryColor").opacity(0.5))
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
