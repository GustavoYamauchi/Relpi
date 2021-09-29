//
//  OrgView.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI

struct OngView: View {
    var ong: Organizacao
    
    var body: some View {
        Text(ong.nome)
    }
}

//struct OrgView_Previews: PreviewProvider {
//    static var previews: some View {
//        OngView(ong: Organizacao(nome: "Casa maria helena"))
//    }
//}
