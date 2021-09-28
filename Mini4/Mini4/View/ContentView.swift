//
//  ContentView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 27/09/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    var body: some View {
        NavigationView{
            custView().navigationTitle("Home")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct custView : View{
    
    @State var msg = ""
    @ObservedObject var viewModel = OngViewModel()
    
    var body: some View{
        VStack{
            List{
                ForEach(viewModel.data){ i in
                    HStack{
                        #if Mini4
                        Text(i.cnpj!)
                        #else
                        NavigationLink(
                            destination: modisy(id: i.id!),
                            label: {
                                Text(i.cnpj!)
                            })
                        #endif
                    }
                    
                }
//                .onDelete{ (index) in
//                    // to remove data on cloud firestore
//                    let id = self.datas.data[index.first!].id
//                    let db = Firestore.firestore().collection("Ong")
//
//                    db.document(id!).delete{ (err) in
//
//                        if err != nil{
//                            print((err?.localizedDescription)!)
//                            return
//                        }
//
//                        print("deleted Successfully !!!")
//                        self.datas.data.remove(atOffsets: index)
//
//                    }
//                }
            }
            HStack{
                TextField("msg", text: $msg).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    print(self.msg)
                    self.addData(msg: self.msg)
                }){
                    Text("Add")
                }.padding()
            }.padding()
        }
    }
    
    // to create and write data on firestore
    func addData(msg: String){
        let db = Firestore.firestore()
        let msg1 = db.collection("Ong").document()
        
        msg1.setData(["id" : msg1.documentID, "cnpj":msg]){ (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            print("sucess")
            self.msg = ""
        }
    }
}

// To modify the data

struct modisy : View {
    @State var txt = ""
    var id = ""
    var body: some View{
        VStack{
            TextField("edit", text: $txt).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                let db = Firestore.firestore().collection("Ong")
                db.document(id).updateData(["cnpj":self.txt]){ (err) in
                    if err != nil{
                        print((err?.localizedDescription)!)
                        return
                    }
                    print("success")
                }
            }){
                Text("Modify")
            }
        }
    }
}

