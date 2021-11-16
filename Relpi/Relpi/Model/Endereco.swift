//
//  Endereco.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import Foundation

struct Endereco: Identifiable, Codable {
    var id: String? //Sem validacao
    var logradouro: String //Sem validacao
    var numero: String //Sem validacao
    var bairro: String //Sem validacao
    var cidade: String //Sem validacao
    var cep: String //Validado
    var estado: String //Validado
}

