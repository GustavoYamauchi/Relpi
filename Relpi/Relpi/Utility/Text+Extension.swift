//
//  Text+Extension.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 18/10/21.
//

import Foundation
import SwiftUI

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.destaque)
            .font(.system(size: 24, weight: .bold, design: .default))
            .padding(.horizontal, 30)
    }
}

struct ContentStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.textContent)
            .font(.system(size: 14, weight: .regular, design: .default))
            .padding(.horizontal, 30)
    }
}

extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
