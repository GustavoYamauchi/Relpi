//
//  CustomTextField.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 16/10/21.
//

import SwiftUI

enum StyleTextField {
    case simple
    case multiline
    case password
}

struct CustomTextField: View {
    
    @Binding var text: String
    @State var placeholder: String
    @Namespace private var animation
    var style: StyleTextField = .simple

    var body: some View {
                
        VStack(spacing: 6) {
            
            HStack(alignment: .bottom) {
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    if text != "" && (style == .simple || style == .password) {
                        Text(placeholder)
                            .foregroundColor(.textPlaceholderTextfield)
                            .matchedGeometryEffect(id: placeholder, in: animation)
                    }
                    
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                        
                        if text == "" && (style == .simple || style == .password) {
                            Text(placeholder)
                                .foregroundColor(.textPlaceholderTextfield)
                                .matchedGeometryEffect(id: placeholder, in: animation)
                        }
                        
                        switch style {
                            case .simple:
                                TextField("", text: $text)
                            case .multiline:
                                MultilineTextField(text: text, placeholder: placeholder)
                            case .password:
                                SecureField(placeholder, text: $text)
                                    .textContentType(.password)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal)
        .background(Color.backgroundTextfield)
        .foregroundColor(.black)
        .cornerRadius(cornerRadius())
        .font(.system(size: 14, weight: .regular, design: .default))
    }
    
    private func cornerRadius() -> CGFloat {
        if style == .simple || style == .password {
            if text == "" {
                return 50
            }
            return 30
        }
        return 15
    }
}

struct MultilineTextField: View {
    
    @State var text: String
    @State var placeholder: String
    @Namespace private var animation

    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            Text(placeholder)
                .foregroundColor(.textPlaceholderTextfield)
                .matchedGeometryEffect(id: placeholder, in: animation)
            
            TextEditor(text: $text)
                .colorMultiply(Color.backgroundTextfield)
                .foregroundColor(.textTextfield)
                .font(.system(size: 14, weight: .regular, design: .default))
        }
    }
}
