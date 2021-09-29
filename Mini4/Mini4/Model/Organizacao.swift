//
//  Organizacao.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import Foundation

struct Organizacao: Identifiable {
    var id: String?
    var nome: String
    var cnpj: String
    var descricao: String
    var telefone: String
    var foto: String?
    var banco: Banco?
    var endereco: Endereco?
    var estoque: [Item]?
}
