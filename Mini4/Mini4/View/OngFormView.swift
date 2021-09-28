//
//  OngFormView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 28/09/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

// To modify the data
struct modisy : View {
    @ObservedObject var viewModel = OngViewModel()
    @State var txt = ""
    var id = ""
    var body: some View{
        VStack{
            TextField("edit", text: $txt).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action:{
                viewModel.updateData(id: id, txt: txt)
                
            }){
                Text("Modify")
            }
        }
    }
}
