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
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 35, height: 35)
                        .foregroundColor(qtd > 0 ? .primaryButton : Color.primaryButton.opacity(0.25))
                    
                    Image("Sub")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15, alignment: .center)
                        .foregroundColor(qtd > 0 ? .textPrimaryButton : Color.textPrimaryButton.opacity(0.25))
                }
            })

            Text("\(qtd)")
                .foregroundColor(.textPlaceholderTextfield)
                .frame(minWidth: 10, idealWidth: 30, maxWidth: 60)
                .font(.system(size: 16, weight: .bold, design: .default))
                //.padding(.horizontal, 17)

            Button(action: {
                qtd += 1
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.primaryButton)
                    
                    Image("Sum")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15, alignment: .center)
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

