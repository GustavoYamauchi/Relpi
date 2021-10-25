//
//  OrgView.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI
import Firebase

struct OngHomeView: View {
    
    var ong: Organizacao
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack {
            Text(ong.nome)
            Text("NOME DO BANCO: \(ong.banco.banco)")
            Text("LOGRADOURO: \(ong.endereco.cidade)")
            Button("logout") {
                loginViewModel.logout()
            }
        }
    }
}
