//
//  FormBancoView.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 04/10/21.
//

import SwiftUI

struct FormBancoView: View {
    @Binding var banco: Banco
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Dados bancários")
                .padding(.top)
                .font(.title)
            
            TextField("Banco", text: $banco.banco).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Agencia", text: $banco.agencia).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Conta", text: $banco.conta).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Pix", text: $banco.pix).textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}



//struct FormBancoView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormBancoView()
//    }
//}
