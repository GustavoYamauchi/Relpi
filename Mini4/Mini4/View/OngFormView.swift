//
//  OngFormView.swift
//  Mini4
//
//  Created by Gustavo Rigor on 28/09/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct OngFormView: View {
    @ObservedObject var viewModel = OngViewModel()
    
    @Binding var ong: Organizacao
    @State private var ongDraft: Organizacao
    
    var isEditing: Bool
    @State var pageIndex: Int = 0
    
    init(ong: Binding<Organizacao>, isEditing: Bool) {
        self.isEditing = isEditing
        
        self._ong = ong
        let endereco = Endereco(logradouro: "Rua ametista", numero: "123", bairro: "Vila Pirajussra", cidade: "São Paulo", cep: "05579-010", estado: "SP")
        self.ongDraft = ong.wrappedValue
        ongDraft.endereco = endereco
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image("ImagePlaceholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                VStack(spacing: 30) {
                    
                    getFormView(pageIndex: pageIndex)
                    
                    HStack {
                        if pageIndex > 0 {
                            Button("Anterior") {
                                previousPage()
                            }
                        }
                        
                        Spacer()
                        
                        if pageIndex < 3 {
                            Button("Próximo") {
                                nextPage()
                            }
                        }
                    }
                    
                    Button("Salvar") {
                        saveOng()
                    }
                    
                    Button("Cancelar") {
                        print("CANCELA TUDO")
                    }
                    
                }
                .padding([.leading, .trailing], 30)
                .toolbar {
                    Button("Alterar foto") {
                        print("alterar")
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .onAppear {
                    ong = (isEditing) ? ong : Organizacao(nome: "", cnpj: "", descricao: "", telefone: "", email: "")
                }
                .navigationBarBackButtonHidden(true)
            }            
        }
    }
        
    private func saveOng() {
        if isEditing {
            ong = ongDraft
            viewModel.updateOng(ong: ong)
        } else {
            ong = ongDraft
            viewModel.addOrgData(org: ong)
            self.ong = Organizacao(nome: "", cnpj: "", descricao: "", telefone: "", email: "")
        }
    }
    
    private func nextPage() {
        if pageIndex < 3 {
            pageIndex += 1
        } else {
            print("última página")
        }
    }
    
    private func previousPage() {
        if pageIndex > 0 {
            pageIndex -= 1
        } else {
            print("primeira página")
        }
    }
    
    @ViewBuilder func getFormView(pageIndex: Int) -> some View {
        switch pageIndex {
        case 0: FormInfoGeralView(ong: ongDraft)
        case 1: FormEnderecoView(endereco: Endereco(logradouro: "Rua ametista", numero: "123", bairro: "Vila Pirajussra", cidade: "São Paulo", cep: "05579-010", estado: "SP"))
        case 2: FormContatoView(ong: ongDraft)
        case 3: FormBancoView(banco: Banco(banco: "", agencia: "", conta: "", pix: ""))
        default: FormInfoGeralView(ong: ongDraft)
        }
    }
    
}



struct OngFormView_Previews: PreviewProvider {
    @State static var ong: Organizacao = Organizacao(nome: "", cnpj: "", descricao: "", telefone: "", email: "", endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
    
    static var previews: some View {
        OngFormView(ong: $ong, isEditing: true)
    }
    
}




