//
//  DoadorHome.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI

struct DoadorHome: View {
    @ObservedObject var viewModel = OngViewModel()
    
    var body: some View {
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
    }
}

struct DoadorHome_Previews: PreviewProvider {
    static var previews: some View {
        DoadorHome()
    }
}
