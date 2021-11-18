//
//  ContentView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationView{
            #if Relpi
            DoadorHome(doadorViewModel: .init())

            #else
            
            if loginViewModel.autenticado {
                SobreOngViewGeral(isOng:true, viewModel: .init(idOng: loginViewModel.id))
            } else {
//                CadastroView(viewModel: .init(mode: .cadastro, usuario: .ong))
                CadastroView(viewModel: .init(mode: .login, usuario: .ong))
            }
            
            #endif
        }.onAppear {
            loginViewModel.autenticado = loginViewModel.isAuthenticated
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color.primaryButton)
    }

}


