//
//  Organizacao.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import Firebase
import FirebaseFirestoreSwift

struct Organizacao: Identifiable, Codable, Equatable {
    var id: String? //Sem validacao
    var nome: String //Sem validacao
    var cnpj: String //Validado
    var descricao: String //Sem validacao
    var telefone: String //Validado
    var email: String //Validado
    var foto: String? //Sem validacao
    var data: Timestamp //Sem validacao
    var banco: Banco //Validado
    var endereco: Endereco
    var estoque: [Item]? //Sem validacao
    
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


