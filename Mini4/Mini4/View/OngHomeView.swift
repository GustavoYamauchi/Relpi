//
//  OrgView.swift
//  Mini4
//
//  Created by Beatriz Sato on 29/09/21.
//

import SwiftUI
import Firebase

struct OngHomeView: View {
    let userService: UserServiceProtocol = UserService()
    @ObservedObject var viewModel: OngHomeViewModel
    
    
//    var ong: Organizacao
    @EnvironmentObject var estoqueViewModel: EstoqueViewModel
    @State private var selectedImage: UIImage?
    @State var itemPesquisado = ""
    @State var itens: [Item] = [Item(nome: "item0", categoria: "alimento", quantidade: 2, urgente: true, visivel: true), Item(nome: "item1", categoria: "alimento", quantidade: 2, urgente: false, visivel: true)]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Bem vindo!")
                .padding(.top, 10)
                .padding(.leading, 25)
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("\(viewModel.ong.nome)")
                .padding(.leading, 25)
                .foregroundColor(Color.gray)
                .font(.system(size: 14, weight: .regular, design: .default))
                .padding(.bottom, 10)
            
            SearchBarView(pesquisando: $itemPesquisado, placeholder: "Pesquisar")
                .padding(.vertical, 20)
            
            ScrollView{
                HStack {
                    ForEach(0..<2) { i in
                        ItemListaView(item: itens[i])
                            .frame(maxHeight: 220)
                    }
                    .padding(.horizontal, 30)
                }
                
                if itens.count < 2{
                    Button(action: {}) {
                        NavigationLink(destination: TelaListaView(data: viewModel.ong.data).environmentObject(EstoqueViewModel(viewModel.ong.id!)),
                                       label: { Text("Lista Completa") })
                    }
                    .buttonStyle(.primaryButton)
                }
                
                // Infos sobre a ONG
                VStack(alignment: .leading, spacing: 20) {
                    Text("Sobre a ONG")
                        .textStyle(TitleStyle())
                    
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .cornerRadius(15)
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 30)
                    } else {
                        Image("ImagePlaceholder")
                            .resizable()
                            .cornerRadius(15)
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 30)
                    }
                    
                    Text(viewModel.ong.descricao)
                        .textStyle(ContentStyle())
                }.padding(.top, 20)
                
                // Contribuir com a ONG
                Button("Ver perfil") {
                    print("F")
                }.buttonStyle(.primaryButton)
                .padding(.top, 20)
            }
            
        }
        
        .navigationBarItems(trailing:  Button(action: { userService.logout() }, label: {
            Text("Logout")
                .foregroundColor(Color.primaryButton)
                .font(.system(size: 16, weight: .bold, design: .default))
        }))
        
        .navigationBarTitle("", displayMode: .inline)
        
        
        .onChange(of: viewModel.ong, perform: { _ in
            populaItens()
        })
        
        .onAppear{
            getImage()
        }
        
    }
    func populaItens(){
        if estoqueViewModel.data.count > 1{
            itens =  estoqueViewModel.data
        }
    }
    
    private func getImage() {
        if let foto = viewModel.ong.foto {
            ImageStorageService.shared.downloadImage(urlString: foto) { image, err in
                DispatchQueue.main.async {
                    selectedImage = image
                }
            }
        }
    }
    
    
}


//struct OngHomeView_Previews: PreviewProvider {
//    @State static var ong = OngViewModel()
//    
//    static var previews: some View {
//        OngHomeView(viewModel: .init(idOng: ong))
//    }
//}
