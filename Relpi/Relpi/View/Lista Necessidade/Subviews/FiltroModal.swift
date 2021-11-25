//
//  FiltroModal.swift
//  Mini4
//
//  Created by Gustavo Rigor on 20/10/21.
//

import SwiftUI

struct FiltroModal: View {
    
    @Binding var mostrarCategorias: Bool
    @Binding var mostrarApenasUrgentes: Bool
    @Binding var mostrandoView: Bool
    @Environment(\.presentationMode) var presentationMode
    private var estadoTela: [Bool] {
        get { return [mostrarCategorias, mostrarApenasUrgentes, mostrarCategorias] }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                
                Text("Filtrar itens")
                    .padding(.top)
                    .foregroundColor(Color.destaque)
                    .font(.system(size: 24, weight: .bold, design: .default))
                
                HStack(spacing: 15){
                    Text("Agrupar por categoria")
                        .font(.system(size: 18, weight: .regular, design: .default))
                    
                    Toggle("Agrupar Categorias", isOn: $mostrarCategorias)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .destaque))
                }.padding(.top, 30)
                
                HStack(spacing: 15){
                    Text("Exibir apenas itens urgentes")
                        .font(.system(size: 18, weight: .regular, design: .default))
                    
                    Toggle("Agrupar Categorias", isOn: $mostrarApenasUrgentes)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .destaque))
                }.padding(.top, 30)
                
                Button("Aplicar filtros") {
                    mostrandoView = false
                }.buttonStyle(.primaryButton)
                .padding(.top, 30)
                
                Button("Limpar filtros") {
                    mostrarCategorias = false
                    mostrarApenasUrgentes = false
                    mostrandoView = false
                }.buttonStyle(.secondaryButton)
                .padding(.top, 30)
                
            }
            .navigationBarItems(
                leading: Button(action: {
                    mostrarCategorias = estadoTela[0]
                    mostrarApenasUrgentes = estadoTela[1]
                    mostrandoView = estadoTela[2]
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("Cancelar")
                            .accentColor(.destaque)
                    }
                }
            )
        }
    }
}

//struct FiltroModal_Previews: PreviewProvider {
//    static var previews: some View {
//        FiltroModal()
//    }
//}
