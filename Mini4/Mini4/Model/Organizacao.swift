//
//  Organizacao.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import Firebase

struct Organizacao: Identifiable, Equatable{
    var id: String?
    var nome: String
    var cnpj: String
    var descricao: String
    var telefone: String
    var email: String
    var foto: String?
    var data: Timestamp
    var banco: Banco
    var endereco: Endereco
    var estoque: [Item]?
    
    static func == (lhs: Organizacao, rhs: Organizacao) -> Bool {
        return lhs.id == rhs.id &&
            lhs.nome == rhs.nome &&
            lhs.cnpj == rhs.cnpj &&
            lhs.descricao == rhs.descricao &&
            lhs.telefone == rhs.telefone &&
            lhs.email == rhs.email &&
            lhs.foto == rhs.foto &&
            lhs.data == rhs.data
    }
}
