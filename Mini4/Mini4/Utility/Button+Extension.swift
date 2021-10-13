//
//  Button+Extension.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 05/10/21.
//

import Foundation
import SwiftUI

enum Styles {
    case primaryButton
    case secondaryButton
    case textButton
    case deleteButton
}

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.textPrimaryButton)
            .background(Color.primaryButton)
            .cornerRadius(50)
            .padding(.horizontal, 30)
            .font(.system(size: 16, weight: .bold, design: .default))
    }
}

struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.textSecondaryButton)
            .background(Color.secondaryButton)
            .cornerRadius(50)
            .overlay(RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.borderSecondaryButton, lineWidth: 2))
            .padding(.horizontal, 30)
            .font(.system(size: 16, weight: .bold, design: .default))
    }
}

struct TextButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color.primaryButton)
            .padding(.horizontal, 30)
            .font(.system(size: 16, weight: .bold, design: .default))
    }
}

struct DeleteButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color.textDeleteButton)
            .padding(.horizontal, 30)
            .font(.system(size: 16, weight: .bold, design: .default))
    }
}

extension Button {
    @ViewBuilder
    func buttonStyle(_ style: Styles) -> some View {
        switch style {
        case .primaryButton:
            self.buttonStyle(PrimaryButton())
        case .secondaryButton:
            self.buttonStyle(SecondaryButton())
        case .textButton:
            self.buttonStyle(TextButton())
        case .deleteButton:
            self.buttonStyle(DeleteButton())
        }
    }
}
