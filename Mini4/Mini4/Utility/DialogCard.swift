//
//  DialogCard.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 13/10/21.
//

import SwiftUI
import UIKit

enum ColorStyle {
    case green
    case yellow
    case red

    var borderColor: Color {
        switch self {
        case .green:
            return .greenBorderDialogCard
        case .yellow:
            return .yellowBorderDialogCard
        case .red:
            return .redBorderDialogCard
        }
    }

    var backgroundColor: Color {
        switch self {
        case .green:
            return .greenBackgroundDialogCard
        case .yellow:
            return .yellowBackgroundDialogCard
        case .red:
            return .redBackgroundDialogCard
        }
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(15)
            .shadow(color: Color.clear, radius: 15, x: 0, y: 0)
    }
}

struct DialogCard: View {
    var text: String
    var colorStyle: ColorStyle
    
    var body: some View {
        HStack {
            Text(text)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .background(colorStyle.backgroundColor)
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15)
                    .stroke(colorStyle.borderColor, lineWidth: 2))
        .padding(.horizontal, 30)
        .font(.system(size: 14, weight: .regular, design: .default))
        .fixedSize(horizontal: false, vertical: true)
    }
}

//struct DialogCard_Previews: PreviewProvider {
//    
//    var text = "Lorem ipsum dolor sit amet. consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
//    
//    static var previews: some View {
//        DialogCard(text: $text)
//    }
//}
