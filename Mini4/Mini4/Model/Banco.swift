//
//  Banco.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import Foundation

struct Banco: Identifiable, Codable {
    var id: String?
    var banco: String //Sem validacao
    var agencia: String //Validado
    var conta: String //Validado
    var pix: String //Sem validacao
}


