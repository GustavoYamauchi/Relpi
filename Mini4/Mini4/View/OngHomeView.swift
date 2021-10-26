//
//  OrgView.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI
import Firebase

struct OngHomeView: View {
    
    var ong: Organizacao
    @EnvironmentObject var estoqueViewModel: EstoqueViewModel
    @State var itemPesquisado = ""
    @State var itens: [Item] = [Item(nome: "item0", categoria: "alimento", quantidade: 2, urgente: true, visivel: true), Item(nome: "item1", categoria: "alimento", quantidade: 2, urgente: false, visivel: true)]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Bem vindo!")
                .padding(.top, 10)
                .padding(.leading, 25)
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("\(ong.nome)")
                .padding(.leading, 25)
                .foregroundColor(Color.gray)
                .font(.system(size: 14, weight: .regular, design: .default))
                .padding(.bottom, 10)
            
            SearchBarView(pesquisando: $itemPesquisado, placeholder: "Pesquisar")
                .padding(.vertical, 20)
            
            HStack {
                ForEach(0..<2) { i in
                    ItemListaView(item: itens[i])
                        .frame(maxHeight: 220)
                }
                .padding(.horizontal, 30)
            }
            
            if itens.count < 2{
                Button(action: {}) {
                    NavigationLink(destination: TelaListaView(data: ong.data).environmentObject(EstoqueViewModel(ong.id!)),
                                   label: { Text("Lista Completa") })
                }
                .buttonStyle(.primaryButton)
            }
            
        
            ScrollView {
                Text(ong.nome)
                Text("NOME DO BANCO: \(ong.banco.banco)")
                Text("LOGRADOURO: \(ong.endereco.cidade)")
            }
        }
        .onChange(of: ong, perform: { _ in
            populaItens()
        })
    }
    func populaItens(){
        if estoqueViewModel.data.count > 1{
            itens =  estoqueViewModel.data
        }
    }
}


struct OngHomeView_Previews: PreviewProvider {
    @State static var ong = OngViewModel()
    
    static var previews: some View {
        OngHomeView(ong: ong.mockOngMariaHelena())
    }
}
