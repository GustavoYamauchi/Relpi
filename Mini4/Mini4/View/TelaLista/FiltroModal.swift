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
    
    var body: some View {
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

        
    }
}

//struct FiltroModal_Previews: PreviewProvider {
//    static var previews: some View {
//        FiltroModal()
//    }
//}