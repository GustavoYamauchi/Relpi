//
//  SobreOngView.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 07/10/21.
//

import SwiftUI

struct SobreOngView: View {
    
    @State private var ong: Organizacao
    @State var search: String = ""
    
    init(ong: Organizacao) {
        self.ong = ong
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 30) {
                
                //Nome e Cidade da ONG
                VStack(alignment: .leading) {
                    Text("\(ong.nome)")
                        .padding(.top)
                        .foregroundColor(Color.sexternary)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    Text("\(ong.endereco.cidade)")
                }
                
                TextField("Search", text: $search)
                
                // Card dos itens
                HStack(spacing: 30) {
                    Image("ImagePlaceholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Image("ImagePlaceholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                // Listar todos os itens da ONG
                Button("Lista completa") {
                    print("Lista completa")
                }.buttonStyle(PrimaryButton())
                
                // Infos sobre a ONG
                VStack(alignment: .leading) {
                    Text("Sobre a ONG")
                        .padding(.top)
                        .foregroundColor(Color.sexternary)
                        .font(.system(size: 24, weight: .bold, design: .default))
                }
                
                Image("ImagePlaceholder")
                    .resizable()
                    .frame(height: 170)
                
                Text("\(ong.descricao)")
                
                // Contribuir com a ONG
                Button("Lista completa") {
                    print("Lista completa")
                }.buttonStyle(PrimaryButton())
                
            }
            
        }
        
    }
    
}

struct SobreOngView_Previews: PreviewProvider {
    @State static var ong = OngViewModel()
    
    static var previews: some View {
        SobreOngView(ong: ong.mockOngMariaHelena())
    }
}
