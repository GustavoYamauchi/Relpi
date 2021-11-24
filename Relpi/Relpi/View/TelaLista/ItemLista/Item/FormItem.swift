//
//  EditarItem.swift
//  Mini4Admin
//
//  Created by Gustavo Yamauchi on 18/10/21.
//

import Foundation
import SwiftUI

struct FormItem: View {
    
    @ObservedObject var itemViewModel: FormItemViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var novaTela: Bool
    
    @State var gestureIsValid = false
    
    // MARK: Gesture
    var changePage : some Gesture{
        DragGesture()
            .onChanged { gesture in
                gestureIsValid = false
                if gesture.translation.height > 50{
                    gestureIsValid = true
                }
                
                if gesture.translation.height < -50{
                    gestureIsValid = true
                }
            }
            .onEnded({ _ in
                if gestureIsValid {
                  hideKeyboard()
                }
            })
    }
    

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack{
                    
                    //Calculos para proporçao
    //                let propEditando = (itemViewModel.modo == .novoItem) ? 1.5 : 1.0
                    let geometryProp = ((geometry.size.height > 700) ? 0.03 : 0.01)// * propEditando
                    let img = (geometry.size.height > 1000) ? 0.4 : 0.3
                    
                    Image(itemViewModel.imagemNome)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.height * CGFloat(img), height: geometry.size.height * CGFloat(img), alignment: .center)
                        .padding(.top, geometry.size.height * CGFloat(geometryProp))
                    

                    Spacer()

                    
                
                    ZStack{
                        VStack (alignment: .leading, spacing: geometry.size.height * CGFloat(geometryProp)){
                            
                            Text(itemViewModel.titulo)
                                .padding(.leading, 30)
                                .padding(.top, 30)
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
                            
                            if itemViewModel.apresentaFeedback {
                                DialogCard(text: itemViewModel.mensagem, colorStyle: itemViewModel.cor)
                            }
                            
                            if itemViewModel.item != itemViewModel.itemInicial{
                                Button("Salvar", action: {
                                    itemViewModel.salvar()
                                    novaTela.toggle()
                                    presentationMode.wrappedValue.dismiss()
                                }).buttonStyle(.primaryButton)
                            }
                            
                            
                            
                            Button(((itemViewModel.item.visivel) ? "Ocultar" : "Desocultar"), action: {
                                itemViewModel.item.visivel.toggle()
                            }).buttonStyle(.secondaryButton)
                            
                            
                            if itemViewModel.modo == .editarItem {
                                Button("Excluir", action: {
                                    itemViewModel.excluirItem()
                                }).buttonStyle(.deleteButton)
                            }
                            else {
                                Button("Cancelar", action: {
                                    presentationMode.wrappedValue.dismiss()
                                }).buttonStyle(.deleteButton)
                            }
                            
                            
                        }
                        .background(Color.primaria).cornerRadius(30, corners: [.topLeft, .topRight])
                        
                    }.frame(width: UIScreen.main.bounds.size.width)
                
                }.background(itemViewModel.item.urgente ?
                                itemViewModel.item.visivel ? Color.urgencia : Color.urgencia.opacity(0.5) :
                                itemViewModel.item.visivel ? Color.regular: Color.regular.opacity(0.5))
            }
            
            if itemViewModel.isLoading {
                LoadingView()
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .gesture(changePage)
        
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

