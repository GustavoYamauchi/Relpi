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
    
    @ObservedObject var enderecoViewModel: EnderecoViewModel
    @ObservedObject var bancoViewModel: BancoViewModel
    
    init(ong: Organizacao) {
        self.ong = ong
        self.enderecoViewModel = EnderecoViewModel(ong.id!)
        self.bancoViewModel = BancoViewModel(ong.id!)
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
                
                SearchBarView(pesquisando: $search, placeholder: "Search")
                
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
                }.buttonStyle(.primaryButton)
                
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
                Button("Contribua") {
                    print("Contribua")
                }.buttonStyle(.primaryButton)
                
            }
            
        }.onAppear {
            if let banco = bancoViewModel.data.first, let enderecoVM = enderecoViewModel.data.first {
                self.ong.banco = banco
                self.ong.endereco = enderecoVM
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
