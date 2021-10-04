//
//  FormInfoGeralView.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 04/10/21.
//

import SwiftUI

struct FormInfoGeralView: View {
    @State var ong: Organizacao
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Informações Gerais")
                .padding(.top)
                .font(.title)
            
            TextField("Nome da Ong", text: $ong.nome).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("CNPJ", text: $ong.cnpj).textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Descrição da ONG", text: $ong.descricao).textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}


//struct FormInfoGeralView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormInfoGeralView()
//    }
//}
