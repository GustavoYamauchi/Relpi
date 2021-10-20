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
        Button(action: {
            self.toggle.toggle()
        }, label: {
            HStack{
                Text("\(selected)")
                    .foregroundColor(.textPlaceholderTextfield)
                Spacer()
                Text("...")
                    .foregroundColor(.textPlaceholderTextfield)
            }
        })
        .buttonStyle(.categoryButton)
        .sheet(isPresented: $toggle, content: {
            ZStack{
                Color.primaria
                VStack{
                    Text(title)
                        .padding(.top, 10)
                        .foregroundColor(Color.primaryButton)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    PickerCustom(array: array, select: $selected)
                    Button("Ok"){
                        self.toggle.toggle()
                    }.buttonStyle(.primaryButton)
                }
            }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        })
        
    }
}

