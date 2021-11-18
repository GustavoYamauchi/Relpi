//
//  Categorias.swift
//  Relpi
//
//  Created by Beatriz Sato on 18/11/21.
//

import Foundation

enum Categorias : String{
    case higiene = "Higiene"
    case alimento = "Alimento"
    case limpeza = "Limpeza"
    case medicamento = "Medicamento"
    case utensilio = "Utensilio"
    case vazio = ""
    var categoria: Categorias {
        switch self {
        case .higiene, .alimento, .limpeza, .medicamento, .utensilio:
            return self
        default:
            return .vazio
        }
    }
    var titulo: String {
        switch self {
        case .higiene: return "Higiene pessoal"
        case .alimento: return "Alimento"
        case .limpeza: return "Produtos de limpeza"
        case .medicamento: return "Medicamentos"
        case .utensilio: return "Utensílios de cozinha"
        default:
            return ""
        }
    }
    
}

