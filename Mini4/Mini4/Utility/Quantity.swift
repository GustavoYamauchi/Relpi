//
//  Quantity.swift
//  Mini4
//
//  Created by Gustavo Yamauchi on 18/10/21.
//

import Foundation
import SwiftUI

struct Quantity: View {
    
    @Binding var qtd : Int
    
    var body: some View {
        
        HStack{
            Button(action: {
                qtd = (qtd > 0) ? qtd - 1 : qtd
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 50, height: 50)
                        .foregroundColor(qtd > 0 ? .primaryButton : Color.primaryButton.opacity(0.25))
                    
                    Image("Sub")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(qtd > 0 ? .textPrimaryButton : Color.textPrimaryButton.opacity(0.25))
                }
            })
            Text("\(qtd)")
                .foregroundColor(.sexternary)
                .font(.system(size: 24, weight: .bold, design: .default))
            Button(action: {
                qtd += 1
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.primaryButton)
                    
                    Image("Sum")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25, alignment: .center)
                        .foregroundColor(Color.textPrimaryButton)
                }
            })
        }
    }
}

//struct Quantity_Previews: PreviewProvider {
//    static var previews: some View {
//        Quantity(qtd: )
//    }
//}

