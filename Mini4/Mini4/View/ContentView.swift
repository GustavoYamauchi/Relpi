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
            #if Mini4
            DoadorHome(doadorViewModel: .init())

            #else
            
            if loginViewModel.autenticado {
                OngHomeView(viewModel: .init(idOng: loginViewModel.id))
            } else {
                CadastroView(viewModel: .init(mode: .cadastro, usuario: .ong))
            }
            
            #endif
        }.onAppear {
            loginViewModel.autenticado = loginViewModel.isAuthenticated
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

}


