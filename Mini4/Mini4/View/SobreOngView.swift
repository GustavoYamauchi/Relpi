//
//  SobreOngView.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 07/10/21.
//

import SwiftUI

struct SobreOngView: View {
    
    @State private var ong: Organizacao
    @State private var selectedImage: UIImage?
    @State private var temp: Bool = false
    
    @ObservedObject var enderecoViewModel: EnderecoViewModel
    @ObservedObject var bancoViewModel: BancoViewModel
    @ObservedObject var estoqueViewModel: EstoqueViewModel
        
    init(ong: Organizacao) {
        self.ong = ong
        self.enderecoViewModel = EnderecoViewModel(ong.id!)
        self.bancoViewModel = BancoViewModel(ong.id!)
        self.estoqueViewModel = EstoqueViewModel(ong.id!)
    }
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 30) {
                
                //Nome e Cidade da ONG
                VStack(alignment: .leading, spacing: 8) {
                    Text(ong.nome)
                        .textStyle(TitleStyle())
                    
                    Text(ong.endereco.cidade)
                        .textStyle(ContentStyle())
                }
                
                let itemCount = ong.estoque?.count ?? 0
                
                if itemCount > 2 {
                    HStack {
                    ForEach(0..<2) { i in
                        ItemListaVerticalView(viewModel: .init(idOng: ong.id!, idItem: ong.estoque![i].id!), trocaDeTela: $temp )
                            .frame(maxHeight: 220)
                    }
                    .padding(.horizontal, 30)
                    }
                    
                    Button(action: {}) {
                        NavigationLink(destination: TelaListaView(telaViewModel: .init(idOng: ong.id!, data: ong.data)).environmentObject(EstoqueViewModel(ong.id!)),
                                       label: {
                                        Text("Lista Completa")
                                       })
                    }
                    .buttonStyle(.primaryButton)
                } else {
                    if itemCount != 0 {
                        HStack {
                            ForEach(0..<estoqueViewModel.data.count) { i in
                                ItemListaVerticalView(viewModel: .init(idOng: ong.id!, idItem: ong.estoque![i].id!), trocaDeTela: $temp)
                                    .frame(maxHeight: 220)
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                }
                
                // Listar todos os itens da ONG
                Button(action: {}) {
                    NavigationLink(destination: TelaListaView(telaViewModel: .init(idOng: ong.id!, data: ong.data)).environmentObject(EstoqueViewModel(ong.id!)),
                                   label: { Text("Lista Completa") })
                }
                .buttonStyle(.primaryButton)
                
                
                
                // Infos sobre a ONG
                VStack(alignment: .leading, spacing: 8) {
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
                    
                    Text(ong.descricao)
                        .textStyle(ContentStyle())
                }
                
                // Contribuir com a ONG
                Button("Contribua") {
                    print("Contribua")
                }.buttonStyle(.primaryButton)
                
            }
            
        }.onAppear {
            getImage()
            if let banco = bancoViewModel.data.first,
               let enderecoVM = enderecoViewModel.data.first {
                self.ong.banco = banco
                self.ong.endereco = enderecoVM
            }
            
            self.ong.estoque = estoqueViewModel.data
        }
    }
    
    private func getImage() {
        if let foto = ong.foto {
            ImageStorageService.shared.downloadImage(urlString: foto) { image, err in
                DispatchQueue.main.async {
                    selectedImage = image
                }
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
