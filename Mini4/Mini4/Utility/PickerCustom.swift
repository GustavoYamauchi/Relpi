//
//  PickerCustom.swift
//  Mini4
//
//  Created by Gustavo Yamauchi on 08/10/21.
//

import Foundation
import SwiftUI

struct PickerCustom: View {
//    @ObservedObject var viewModel: BancoViewModel
    
    @State var array = [""]
    
    @Binding var select: String
    var body: some View {

        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.size.width*((UIScreen.main.bounds.size.width > 1000) ? 0.61: 0.81), height: 32)
                .foregroundColor(Color.secundaria)
            
            Picker("Color", selection: $select){
                ForEach(array, id: \.self){
                    Text($0)
                }
            }.pickerStyle(WheelPickerStyle())
        }.padding(30)
    }
    
}
