//
//  sobreOngDoador.swift
//  Mini4
//
//  Created by Gustavo Rigor on 09/11/21.
//
import SwiftUI

struct sobreOngDoadorView: View {
    @ObservedObject var viewModel: SobreOngDoadorViewModel
    @Environment(\.openURL) var openURL
    
    var imagemOngView: some View{
        Image(uiImage: viewModel.selectedImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    var nomeOngView: some View{
        Text(viewModel.nomeOngLabel)
            .textStyle(TitleStyle())
    }
    
    var descricaoOngView: some View{
        Text(viewModel.descricaoOngLabel)
            .textStyle(ContentStyle())
    }
    
    var enderecoOngView: some View{
        HStack{
            Image("localizacao")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
            Text(viewModel.enderecoOngLabel)
                .foregroundColor(Color.textContent)
                .font(.system(size: 14, weight: .regular, design: .default))
        }.padding(.horizontal, 30)
    }
    
    var contatoOngView: some View{
        HStack{
            Image("contato")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
            Text(viewModel.telefoneOngLabel)
                .foregroundColor(Color.textContent)
                .font(.system(size: 14, weight: .regular, design: .default))
        }.padding(.horizontal, 30)
    }
    
    var emailOngView: some View{
        HStack{
            Image("email")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
            Text(viewModel.emailOngLabel)
                .foregroundColor(Color.textContent)
                .font(.system(size: 14, weight: .regular, design: .default))
        }.padding(.horizontal, 30)
    }
    
    var visteSiteOngView: some View{
        Button(action: {
            openURL(URL(string: "https://www.casamariahelenapaulina.org.br")!)
        }){
            Text("Visite o site")
        }.buttonStyle(.primaryButton)
    }
    
    var body: some View {
        ScrollView{
            VStack{
                imagemOngView
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 20){
                    nomeOngView
                    descricaoOngView
                    enderecoOngView
                    contatoOngView
                    emailOngView
                    visteSiteOngView
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
