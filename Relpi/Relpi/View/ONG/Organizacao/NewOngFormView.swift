//
//  NewOngFormView.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 28/10/21.
//

import SwiftUI
import Firebase

struct NewOngFormView: View {
    @ObservedObject var viewModel: OngFormViewModel
    
    @Environment(\.presentationMode) var presentationMode
    // upload de foto
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isImagePickerDisplaying = false
        
    @State var pageIndex: Int = 0
        
    
    //MARK: - View
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    if viewModel.selectedImage != nil {
                        Image(uiImage: viewModel.selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if viewModel.downloadedImage != nil {
                        Image(uiImage: viewModel.downloadedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image("ImagePlaceholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 30) {
                        
                        getFormView(pageIndex: pageIndex)
                        
                        if viewModel.apresentaFeedback {
                            DialogCard(text: viewModel.mensagem, colorStyle: viewModel.cor)
                        }
                        
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
                        viewModel.salvar()
                    }.buttonStyle(PrimaryButton())
                    
                    if viewModel.modo == .perfil {
                        Button("Cancelar") {
                            viewModel.apresentaFeedback = false
                            viewModel.selectedImage = nil
                            presentationMode.wrappedValue.dismiss()
                        }.buttonStyle(SecondaryButton())

                    }
                        
                    if viewModel.modo == .cadastro {
                        NavigationLink(destination: OngHomeView(viewModel: .init(idOng: viewModel.ong.id!)), isActive: $viewModel.redirectHome) {
                            EmptyView()
                        }
                    }
                        
                    }
                    .navigationBarHidden(viewModel.isLoading)
                    .padding([.leading, .trailing], 30)
                    .toolbar {
                        Button("Alterar foto") {
                            self.sourceType = .photoLibrary
                            self.isImagePickerDisplaying.toggle()
                        }
                    }
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarBackButtonHidden(true)
                    .sheet(isPresented: self.$isImagePickerDisplaying) {
                        ImagePickerView(selectedImage: $viewModel.selectedImage, sourceType: self.sourceType)
                    }
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }
    
    // MARK: - Métodos
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
    
    // MARK: - Form Subview
    @ViewBuilder func getFormView(pageIndex: Int) -> some View {
        switch pageIndex {
            case 0: InfoGeralFormView(ong: $viewModel.ong)
            case 1: EnderecoFormView(endereco: $viewModel.ong.endereco, isEditing: true)
            case 2: ContatoFormView(ong: $viewModel.ong)
            case 3: BancoFormView(banco: $viewModel.ong.banco, isEditing: true)
            default: InfoGeralFormView(ong: $viewModel.ong)
        }
    }
}