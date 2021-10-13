//
//  DoadorHome.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI

struct DoadorHome: View {
    
    @ObservedObject var viewModel = OngViewModel()
    
    @State var selected: String = "Sla"
    
    var body: some View {
        VStack{
            Text(selected)
            List{
                ForEach(viewModel.data){ i in
                    HStack {
                        NavigationLink(
                            destination: OngView(ong: i),
                            label: {
                                Text(i.nome)
                            })
                    }
                }
            }
            Category(title: "Teste", array: ["a", "b", "c"], selected: $selected)
        }
    }
}

struct DoadorHome_Previews: PreviewProvider {
    static var previews: some View {
        DoadorHome()
    }
}
