//
//  Organizacao.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import Firebase

struct Organizacao: Identifiable, Codable {
    var id: String?
    var nome: String
    var cnpj: String
    var descricao: String
    var telefone: String
    var email: String
    var foto: String?
    //var data: Timestamp
    var banco: Banco
    var endereco: Endereco
    var estoque: [Item]?
}


