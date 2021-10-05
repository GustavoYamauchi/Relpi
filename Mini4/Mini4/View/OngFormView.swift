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
    @ObservedObject var ongViewModel = OngViewModel()
    @ObservedObject var enderecoViewModel: EnderecoViewModel
    
    // organização que está no array da viewModel
    @Binding var ong: Organizacao
    // organização usada como rascunho
    @State private var ongDraft: Organizacao
    
    var isEditing: Bool
    @State var pageIndex: Int = 0
    
    init(ong: Binding<Organizacao>,
         isEditing: Bool,
         enderecoViewModel: EnderecoViewModel) {
        self.isEditing = isEditing
        
        self._ong = ong
        self.ongDraft = ong.wrappedValue
        self.enderecoViewModel = enderecoViewModel
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
                        ongDraft = ong
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
                // não tá funcionando, porque é do tipo binding
//                .onAppear {
//                    ong = (isEditing) ? ong : getNewOrg()
//                }
                .navigationBarBackButtonHidden(true)
            }            
        }
    }
        
    private func saveOng() {
        // se já existir ong, atualiza
        if isEditing {
            ong = ongDraft
            ongViewModel.updateOng(ong: ong)
        } else {
            // adiciona nova
            ong = ongDraft
            ongViewModel.addOrgData(org: ong)
            self.ongDraft = getNewOrg()
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
    
    private func getNewOrg() -> Organizacao {
        return Organizacao(
            nome: "", cnpj: "", descricao: "", telefone: "", email: "",
            banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
            endereco: Endereco(logradouro: "", numero: "", complemento: "", bairro: "", cidade: "", cep: "", estado: ""))
    }
    
    @ViewBuilder func getFormView(pageIndex: Int) -> some View {
        switch pageIndex {
        case 0: FormInfoGeralView(ong: $ongDraft)
//        case 1: FormEnderecoView(endereco: $ongDraft.endereco)
        case 1: EnderecoFormView(viewModel: EnderecoViewModel(ong.id!), endereco: ongDraft.endereco, isEditing: true)
        case 2: FormContatoView(ong: $ongDraft)
//        case 3: FormBancoView(banco: $ongDraft.banco)
        case 3: BancoFormView(viewModel: BancoViewModel(ong.id!), banco: ongDraft.banco, isEditing: true)
        default: FormInfoGeralView(ong: $ongDraft)
        }
    }
    
}



struct OngFormView_Previews: PreviewProvider {
    @State static var ong: Organizacao = Organizacao(
        nome: "", cnpj: "", descricao: "", telefone: "", email: "",
        banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
        endereco: Endereco(logradouro: "", numero: "", complemento: "", bairro: "", cidade: "", cep: "", estado: ""))
    
    static var previews: some View {
        OngFormView(ong: $ong, isEditing: true, enderecoViewModel: EnderecoViewModel("1"))
    }
    
}




