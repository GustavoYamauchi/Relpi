//
//  ExplorarOngView.swift
//  Mini4
//
//  Created by Douglas Cardoso Ferreira on 25/10/21.
//

import SwiftUI

struct ExplorarOngView: View {
    
    //MARK: - Properties & Variables
    private var ongs = [Organizacao]()
    @State private var listaVertical = true
    @State private var mostrarFiltros = false
    private var array = ["SP", "RJ"]
    @State private var estadoSelecionado = ""
    
    //MARK: - Init
    init(ongs: [Organizacao]) {
        self.ongs = ongs
    }
    
    //MARK: - View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HStack {
                    Image("filter")
                        .renderingMode(.template)
                        .foregroundColor(mostrarFiltros ? .primaryButton : .backgroundPrimarySearch)
                        .frame(width: 40, height: 40, alignment: .center)
                        .onTapGesture {
                            mostrarFiltros = true
                            Category(array: array, selected: $estadoSelecionado)
                        }
                    
                    Spacer()
                    Image("collection")
                        .renderingMode(.template)
                        .foregroundColor(!listaVertical ? .primaryButton : .backgroundPrimarySearch)
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            listaVertical = false
                        }
                    
                    Image("table")
                        .renderingMode(.template)
                        .foregroundColor(listaVertical ? .primaryButton : .backgroundPrimarySearch)
                        .frame(width: 40, height: 40, alignment: .center)
                        .onTapGesture {
                            listaVertical = true
                        }
                }.padding(.horizontal, 30)
                .padding(.vertical, 20)
                
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(ongs) { ong in
                        if listaVertical {
                            Button(action: {}) {
                                NavigationLink(destination: SobreOngView(ong: ong),
                                               label: {
                                                Text(ong.nome)
                                                    .frame(minWidth: 0, maxWidth: .infinity)
                                               })
                            }
                            .buttonStyle(.secondaryButton)
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Button(action: {}) {
                                    NavigationLink(destination: SobreOngView(ong: ong),
                                                   label: {
                                                    Text(ong.nome)
                                                        .textStyle(TitleStyle())
                                                   })
                                }
                                
                                let image = getImage(ong: ong)
                                if image != nil {
                                    Image(uiImage: image!)
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
                                
                                Text(ong.endereco.cidade)
                                    .textStyle(ContentStyle())
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Function
    private func getImage(ong: Organizacao) -> UIImage? {
        if ong.foto != "" {
            let url = URL(string: ong.foto!)
            let data = try? Data(contentsOf: url!)
            return UIImage(data: data!)
        } else {
            return nil
        }
    }
}

//MARK: - Preview
struct ExplorarOngView_Previews: PreviewProvider {
    static var previews: some View {
        ExplorarOngView(ongs: [Organizacao]())
    }
}
