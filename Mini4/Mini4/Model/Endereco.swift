//
//  Endereco.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import Foundation

struct Endereco: Identifiable {
    var id: String?
    var logradouro: String
    var numero: String
//    var complemento: String?
    var bairro: String
    var cidade: String
    var cep: String
    var estado: String
}

