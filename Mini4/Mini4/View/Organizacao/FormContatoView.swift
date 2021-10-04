//
//  FormContatoView.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 04/10/21.
//

import SwiftUI

struct FormContatoView: View {
    @State var ong: Organizacao
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Contato")
                .padding(.top)
                .font(.title)
            
            TextField("Telefone", text: $ong.telefone).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("E-mail", text: $ong.email).textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

//struct FormContatoView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormContatoView(ong: <#Organizacao#>)
//    }
//}
