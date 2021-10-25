//
//  OngLogadaViewModel.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 22/10/21.
//

import SwiftUI
import Firebase

class OngLogadaViewModel: ObservableObject {
    
    @ObservedObject var ongViewModel = OngViewModel()
    @ObservedObject var enderecoViewModel: EnderecoViewModel
    @ObservedObject var bancoViewModel: BancoViewModel

    let id: String

    init(id: String) {
        self.id = id
        self.enderecoViewModel = EnderecoViewModel(id)
        self.bancoViewModel = BancoViewModel(id)
    }
    
    func nome() -> String {
        return ongViewModel.data.first(where: {id == $0.id})?.nome ?? "sem ong"
    }
    
    func getOrg() -> Organizacao {
        if let org = ongViewModel.data.first(where: {$0.id == self.id} ), let banco = bancoViewModel.data.first,
           let endereco = enderecoViewModel.data.first {
            return Organizacao(id: org.id, nome: org.nome, cnpj: org.cnpj, descricao: org.descricao, telefone: org.telefone, email: org.email, data: org.data, banco: banco, endereco: endereco)
        } else {
            return ongViewModel.gerarNovaOng()
        }
    }
}
