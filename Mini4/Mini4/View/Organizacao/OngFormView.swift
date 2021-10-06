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
    @ObservedObject var bancoViewModel: BancoViewModel
    
    // organização que está no array da viewModel
    @Binding var ong: Organizacao
    // organização usada como rascunho
    @State private var ongRascunho: Organizacao
    
    var isEditing: Bool
    @State var pageIndex: Int = 0
    
    init(ong: Binding<Organizacao>,
         isEditing: Bool) {
        self.isEditing = isEditing
        
        self._ong = ong
        self.ongRascunho = ong.wrappedValue
        
        self.enderecoViewModel = EnderecoViewModel(ong.wrappedValue.id!)
        self.bancoViewModel = BancoViewModel(ong.wrappedValue.id!)
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
                    }.foregroundColor(Color("primaryButton"))
                    .font(.system(size: 16, weight: .bold, design: .default))

                    Button("Salvar") {
                        saveOng()
                    }.buttonStyle(PrimaryButton())
                    
                    Button("Cancelar") {
                        ongRascunho = ong
                        print("CANCELA TUDO")
                    }.buttonStyle(SecondaryButton())
                    
                }
                .padding([.leading, .trailing], 30)
                .toolbar {
                    HStack{
                        NavigationLink(destination: TelaListaView(viewModel: EstoqueViewModel(ong.id!)),
                        label: {
                            Text("Lista")
                        })
                        Button("Alterar foto") {
                            print("alterar")
                        }
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .onAppear {
                    ong.endereco = enderecoViewModel.data.first!
                    ong.banco = bancoViewModel.data.first ?? Banco(banco: "", agencia: "", conta: "", pix: "")
                    ongRascunho = ong
                }
                .navigationBarBackButtonHidden(true)
            }            
        }
    }
        
    private func saveOng() {
        // se já existir ong, atualiza
        if isEditing {
            ong = ongRascunho
            ongViewModel.updateOng(ong: ong)
            enderecoViewModel.updateEndereco(endereco: ong.endereco)
            bancoViewModel.updateBanco(banco: ong.banco)
        } else {
            // adiciona nova
            ong = ongRascunho
            ongViewModel.addOrgData(org: ong)
            enderecoViewModel.addEnderecoData(endereco: ong.endereco)
            bancoViewModel.updateBanco(banco: ong.banco)
            self.ongRascunho = getNewOrg()
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
        case 0: InfoGeralFormView(ong: $ongRascunho)
        case 1: EnderecoFormView(viewModel: enderecoViewModel, endereco: $ongRascunho.endereco, isEditing: true)
        case 2: ContatoFormView(ong: $ongRascunho)
        case 3: BancoFormView(viewModel: bancoViewModel, banco: $ongRascunho.banco, isEditing: true)
        default: InfoGeralFormView(ong: $ongRascunho)
        }
    }
    
}


struct OngFormView_Previews: PreviewProvider {
    @State static var ong: Organizacao = Organizacao(
        nome: "", cnpj: "", descricao: "", telefone: "", email: "",
        banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
        endereco: Endereco(logradouro: "", numero: "", complemento: "", bairro: "", cidade: "", cep: "", estado: ""))
    
    static var previews: some View {
        OngFormView(ong: $ong, isEditing: true)
    }
    
}




