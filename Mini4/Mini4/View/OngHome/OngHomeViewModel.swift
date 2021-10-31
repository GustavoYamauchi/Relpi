//
//  OngHomeViewModel.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 30/10/21.
//

import SwiftUI

// primeiro lugar que carrega a view, source of truth?
// nas outras telas, usa o binding?

final class OngHomeViewModel: ObservableObject {
    let ongService: OngServiceProtocol
    
    @Published var ong: Organizacao
    
    init(ong: Organizacao, ongService: OngServiceProtocol = OngService()) {
        self.ongService = ongService
        
        self.ong = ong        
    }
    
    private func fetchOng(idOng: String) {
        ongService.getOng(idOng: idOng) { [weak self] result in

            switch result {
            case .success(let ong):
                self?.ong = ong

            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

struct HomeView: View {
    
    var body: some View {
        Text("logado")
    }
}
