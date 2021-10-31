//
//  OngHomeViewModel.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 30/10/21.
//

import SwiftUI
import Firebase

// primeiro lugar que carrega a view, source of truth?
// nas outras telas, usa o binding?

final class OngHomeViewModel: ObservableObject {
    let ongService: OngServiceProtocol
    
    @Published var ong: Organizacao
    
    init(idOng: String, ongService: OngServiceProtocol = OngService()) {
        self.ongService = ongService
        
        self.ong = Organizacao(id: idOng, nome: "", cnpj: "", descricao: "", telefone: "", email: "", foto: "", data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""), endereco: Endereco( logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""), estoque: [Item]())
        
        fetchOng(idOng: idOng)
    }
    
    private func fetchOng(idOng: String) {
        ongService.getOng(idOng: idOng) { [weak self] result in

            switch result {
            case .success(let ong):
                DispatchQueue.main.async {
                    self?.ong = ong
                }

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
