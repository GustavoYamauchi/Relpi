//
//  LoadingView.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 09/11/21.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.white)
                .opacity(0.9)
                .ignoresSafeArea()
            ProgressView("Carregando informações")
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.white))
                )
                .shadow(radius: 10)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
