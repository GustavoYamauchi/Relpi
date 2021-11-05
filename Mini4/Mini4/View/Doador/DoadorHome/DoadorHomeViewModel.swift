//
//  DoadorHomeViewModel.swift
//  Mini4
//
//  Created by Beatriz Sato on 04/11/21.
//

import SwiftUI
import Firebase

final class DoadorHomeViewModel: ObservableObject {
    let ongService: OngServiceProtocol
    
    let rangeOng = 3
    
    @Published var ongs: [Organizacao]
    @Published var isLoggedIn = false
    
    init(ongService: OngServiceProtocol = OngService()) {
        self.ongService = ongService
        ongs = [Organizacao]()
        fetchOngs()
    }
    
    // MARK: - Views
    var mensagemLogin: String {
        return "Para favoritar ONGs e salvar itens na sua caixa de doação, faça login :)"
    }
    
    var searchBarPlaceholder: String {
        return "Pesquisar"
    }
    
    var nomeImagemLogo: String {
        return "logo_light"
    }
    
    var explorarOngLabel: String {
        return "Explorar ONGs"
    }
    
    func ongName(at index: Int) -> String {
        return ongs[index].nome
    }
    
    func quantidadeOngs() -> Int {
        return ongs.count
    }
    
    func ong(at index: Int) -> Organizacao {
        return ongs[index]
    }
    
    var botaoTodasOngs: String {
        return "Ver todas"
    }
    
    // MARK: - Métodos service
    func fetchOngs() {
        ongService.fetchOngs { [weak self] result in
            switch result {
            case .success(let ongs):
                DispatchQueue.main.async {
                    self?.ongs = ongs
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
