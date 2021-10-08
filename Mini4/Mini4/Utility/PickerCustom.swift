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
            RoundedRectangle(cornerRadius: 100)
                .frame(width: UIScreen.main.bounds.size.width-18, height: 32)
                .foregroundColor(.blue)
            
            Picker("Color", selection: $select){
                ForEach(array, id: \.self){
                    Text($0)
                }
            }
        }
    }
    
}
