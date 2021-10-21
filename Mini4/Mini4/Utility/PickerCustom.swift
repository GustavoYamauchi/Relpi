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
            RoundedRectangle(cornerRadius: 5)
                .frame(width: UIScreen.main.bounds.size.width-75, height: 32)
                .foregroundColor(Color.secundaria)
            
            Picker("Color", selection: $select){
                ForEach(array, id: \.self){
                    Text($0)
                }
            }
        }.padding(30)
    }
    
}
