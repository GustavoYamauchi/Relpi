//
//  StringExtend.swift
//  Mini4
//
//  Created by Gustavo Rigor on 28/09/21.
//

import Foundation

extension Any {
    func castString(_ variable: Any) -> String {
        if let str = variable as? String {
            return str
        }
        return ""
    }
}
