//
//  Item.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import Foundation

struct Item: Identifiable {
    var id: String?
    var nome: String
    var categoria: String
    var quantidade: Int
    var urgente: Bool
    var visivel: Bool
}
