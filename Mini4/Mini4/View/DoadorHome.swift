//
//  DoadorHome.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI

struct DoadorHome: View {
    
    @ObservedObject var viewModel = OngViewModel()
        
    var body: some View {
        VStack {
            ForEach(viewModel.data) { ong in
                HStack {
                    NavigationLink(destination: SobreOngView(ong: ong)) {
                        Text("\(ong.nome)")
                    }
                    .buttonStyle(PrimaryButton())
                }
            }
        }
    }
    
}

struct DoadorHome_Previews: PreviewProvider {
    static var previews: some View {
        DoadorHome()
    }
}
