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
            #if Mini4
            DoadorHome()
            #else
            CadastroView()
            
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#if Mini4
#else
struct custView : View{
    
    @State var msg = "Teste"
    @ObservedObject var viewModel = OngViewModel()
    @State var novaOrg: Organizacao = Organizacao(id: NSUUID().uuidString, nome: "", cnpj: "", descricao: "", telefone: "", email: "", data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""), endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
    
    var body: some View{
        VStack{
            Text(msg)
            List{
                ForEach(0..<viewModel.data.count, id: \.self){ i in
                    HStack{
                        NavigationLink(
                            destination: OngFormView(ong: $viewModel.data[i], isEditing: true),
                            label: {
                                Text(viewModel.data[i].nome)
                        })
                    }
                    
                }
                NavigationLink(destination: OngFormView(ong: $novaOrg, isEditing: false), label: { Text("Nova Ong") })
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
        }
    }
}
#endif


