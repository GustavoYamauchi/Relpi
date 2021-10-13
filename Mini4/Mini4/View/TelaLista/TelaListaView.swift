//
//  TelaListaView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 06/10/21.
//

import SwiftUI
import Firebase

struct TelaListaView: View {
    @ObservedObject var viewModel: EstoqueViewModel
    var data: Timestamp
    var gridItemLayout = [GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30), GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 30)]
    
    @State var itemPesquisado = ""
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Lista de necessidades")
                .padding(.top)
                .padding(.leading, 25)
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Atualizado em \(converteData()).")
                .padding(.leading, 25)
                .foregroundColor(Color.gray)
                .font(.system(size: 14, weight: .regular, design: .default))
                .padding(.bottom, 10)
            
            SearchBarView(pesquisando: $itemPesquisado, placeholder: "Pesquisar")
            
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.quintenary, lineWidth: 2)
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color.quintenary.opacity(0.2))
                Text("Para realizar a doação, entre em contato com a ONG. Nossa plataforma apenas cataloga os itens demandados! :)")
                    .padding(10)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .multilineTextAlignment(.leading)
            }
            .frame(idealWidth: .infinity, minHeight: 70, idealHeight: 80, maxHeight: 80, alignment: .center)
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
            
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(viewModel.data.filter({$0.nome.contains(itemPesquisado) || itemPesquisado.isEmpty})){ item in
                        ItemListaView(item: item)
                            .frame(minWidth: 50, minHeight: 220)
                            .padding(.bottom, 20)
                    }
                }.padding(.horizontal, 30)
            }
        }
        .onAppear{
            viewModel.data.sort {$0.urgente && !$1.urgente}
        }
        
    }
    
    func converteData() -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(self.data.seconds))
        
        let formatador = DateFormatter()
        let formatadorHora = DateFormatter()
        formatador.dateStyle = .short
        formatadorHora.locale = .current
        formatador.locale = .current
        let template = "MM/dd/yyyy"
        let templateHora = "HH:mm"
        if let dateFormate = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: formatador.locale), let hourFormate = DateFormatter.dateFormat(fromTemplate: templateHora, options: 0, locale: formatador.locale){
            formatador.dateFormat = dateFormate
            formatadorHora.dateFormat = hourFormate
            return "\(formatador.string(from: date)) às \(formatadorHora.string(from: date))"
        }
        return ""
    }
}

