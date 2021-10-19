//
//  Category.swift
//  Mini4
//
//  Created by Gustavo Yamauchi on 08/10/21.
//

import Foundation
import SwiftUI

struct Category: View {
//    @ObservedObject var viewModel: BancoViewModel
    
    @State var toggle: Bool = false
    @State var title: String = "Categoria"
    @State var array = [""]
    @Binding var selected: String
    
    var body: some View {
        Button("\(selected)") {
            self.toggle.toggle()
        }
        .buttonStyle(.primaryButton)
        .sheet(isPresented: $toggle, content: {
            ZStack{
                Color.primary
                VStack{
                    Text(title)
                    PickerCustom(array: array, select: $selected)
                    Button("Ok"){
                        self.toggle.toggle()
                    }.buttonStyle(.primaryButton)
                }
            }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        })
        
    }
}

