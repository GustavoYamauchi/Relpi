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
    @State var title: String = "Title"
    @State var array = [""]
    @Binding var selected: String
    
    var body: some View {
        Button("Teste") {
            self.toggle.toggle()
        }
        .sheet(isPresented: $toggle, content: {
            VStack{
                Text(title)
                PickerCustom(array: array, select: $selected)
                Button(title){
                    
                }
            }
        })
    }
}
