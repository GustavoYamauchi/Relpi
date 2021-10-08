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
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Lista de necessidades")
                .padding(.top)
                .padding(.leading, 25)
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text(converteData())
                .padding(.leading, 25)
                .foregroundColor(Color.black)
                .font(.system(size: 18, weight: .regular, design: .default))
            
            ScrollView {
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(viewModel.data){ item in
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
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}

