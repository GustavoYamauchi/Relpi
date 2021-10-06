//
//  TelaListaView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 06/10/21.
//

import SwiftUI

struct TelaListaView: View {
    @ObservedObject var viewModel: EstoqueViewModel
    
    var body: some View {
        VStack{
            List{
                ForEach(viewModel.data){ item in
                    ItemListaView(item: item)
                }
            }
        }
    }
}

