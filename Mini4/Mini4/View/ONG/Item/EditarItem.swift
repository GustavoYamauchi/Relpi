//
//  EditarItem.swift
//  Mini4Admin
//
//  Created by Gustavo Yamauchi on 18/10/21.
//

import Foundation
import SwiftUI

struct EditarItem: View {
    
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
                    
                    Text("Urgente")
                        .foregroundColor(.textPlaceholderTextfield)
                        .lineLimit(1)
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .padding(.trailing, 10)
                    
                    Toggle("Agrupar Categorias", isOn: $itemViewModel.item.urgente)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .destaque))
                    
                }.padding(.horizontal, 30)
                
                Button("Salvar", action: {
                    itemViewModel.salvar()
                }).buttonStyle(.primaryButton)

                
                if itemViewModel.modo == .editarItem {
                    Button("Ocutar", action: {
                        itemViewModel.item.visivel.toggle()
                        
                    }).buttonStyle(.secondaryButton)
                    
                    Button("Excluir", action: {
                        itemViewModel.excluirItem()
                    }).buttonStyle(.deleteButton)
                }

                
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
