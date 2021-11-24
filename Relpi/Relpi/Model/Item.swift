//
//  Item.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import Foundation

struct Item: Identifiable, Codable, Equatable {
    var id: String?
    var nome: String
    var categoria: String
    var quantidade: Int
    var urgente: Bool
    var visivel: Bool
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id &&
            lhs.nome == rhs.nome &&
            lhs.categoria == rhs.categoria &&
            lhs.quantidade == rhs.quantidade &&
            lhs.urgente == rhs.urgente &&
            lhs.visivel == rhs.visivel
    }
}
