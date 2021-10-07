//
//  TelaListaView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 06/10/21.
//

import SwiftUI

struct TelaListaView: View {
    @ObservedObject var viewModel: EstoqueViewModel
    var gridItemLayout = [GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30), GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30)]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Lista de necessidades")
                .padding(.top)
                .padding(.leading, 25)
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(viewModel.data){ item in
                        ItemListaView(item: item)
                            .frame(minWidth: 50, minHeight: 220)
                            .padding(.bottom, 20)
                    }
                }.padding(.horizontal, 30)
            }
        }
        
    }
}

