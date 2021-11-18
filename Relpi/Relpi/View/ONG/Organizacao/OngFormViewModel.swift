//
//  OngFormViewModel.swift
//  Mini4Admin
//
//  Created by Beatriz Sato on 28/10/21.
//

import SwiftUI
import Firebase

class OngFormViewModel: ObservableObject {
    let modo: Modo
    
    let userService: UserServiceProtocol
    let ongService: OngServiceProtocol
    
    @Published var ong: Organizacao
    @Published var selectedImage: UIImage?
    var downloadedImage: UIImage?
    
    @Published var redirectHome = false
    @Published var apresentaFeedback = false
    @Published var mensagem = ""
    var cor: ColorStyle = .green
    @Published var isLoading = false
    
    weak var ongHomeViewModel: OngHomeViewModel?
    // MARK: - Inicializador
    
    init(modo: Modo,
         userService: UserServiceProtocol = UserService(),
         ongService: OngServiceProtocol = OngService(),
         image: UIImage?,
         ongHome: Organizacao?,
         ongHomeViewModel: OngHomeViewModel?
         )
    {
        self.modo = modo
        self.userService = userService
        self.ongService = ongService
        
        ong = Organizacao(id: userService.usuarioAtual()?.uid,
            nome: "", cnpj: "", descricao: "", telefone: "", email: "",
            data: Timestamp(date: Date()), banco: Banco(banco: "", agencia: "", conta: "", pix: ""),
            endereco: Endereco(logradouro: "", numero: "", bairro: "", cidade: "", cep: "", estado: ""))
        
        self.ongHomeViewModel = ongHomeViewModel
        
        if modo == .perfil {
            if let ong = ongHome {
                self.ong = ong
            }
            
            if let image = image {
                downloadedImage = image
            }
        }
        
    }
    
    // MARK: - Métodos
    
    func deleteOng() {
        ongService.deleteOng(idOng: ong.id!) { [weak self] result in
            switch result {
            case .success():
                print("deletado")
                // tem que ir pra cadastro view
                
            case .failure(let err):
                self?.mensagem = err.localizedDescription
                self?.cor = .red
                self?.apresentaFeedback = true
            }
        }
    
    }
    
    
    func salvar() {
        verificaCampos()
        if !apresentaFeedback{
            cor = .green
            isLoading = true
            switch modo {
            case .cadastro:
                if selectedImage != nil {
                    salvaComImagem()
                } else {
                    salvaSemImagem()
                }
            case .perfil:
                // verifica se quer atualizar imagem
                if selectedImage != nil && selectedImage?.pngData() != downloadedImage?.pngData() {
                    salvaComImagem()
                } else {
                    salvaSemImagem()
                }
            }
            isLoading = false
        }
    }
    
    private func salvaSemImagem() {
        print("salvando sem imagem")
        // atualiza no firebase sem atualizar imagem
        self.ongService.create(self.ong) { [weak self] result in
            self?.isLoading = true
            switch result {
            case .success:
                if self?.modo == .cadastro {
                    self?.redirectHome = true
                    print("redirect home")
                    
                } else {
                    self?.mensagem = "Atualizado com sucesso!"
                    self?.apresentaFeedback = true
                    
                    // faz a ongHomeView model atualizar através de protocolo e delegate
                    if self?.ongHomeViewModel != nil {
                        self?.ongHomeViewModel?.atualizarHome()
                    }
                }
                self?.isLoading = false
            case .failure(let err):
                self?.isLoading = false
                self?.mensagem = err.localizedDescription
                self?.apresentaFeedback = true
            }
        }
    }
    
    
    private func salvaComImagem() {
        if selectedImage != nil {
            print("fazendo upload de imagem")
            isLoading = true
            ImageStorageService.shared.uploadImage(idOng: ong.id!, image: selectedImage!) { [weak self] imageUrl, err in
                if let err = err {
                    self?.mensagem = err.localizedDescription
                    self?.apresentaFeedback = true
                }

                self?.ong.foto = imageUrl
                self?.downloadedImage = self?.selectedImage
                self?.selectedImage = nil

                // adiciona no firebase
                self?.ongService.create(self!.ong) { [weak self] result in
                    switch result {
                    case .success:
                        if self?.modo == .cadastro {
                            self?.redirectHome = true
                        } else {
                            self?.mensagem = "Atualizado com sucesso!"
                            self?.apresentaFeedback = true
                            if self?.ongHomeViewModel != nil {
                                self?.ongHomeViewModel?.atualizarHomeComImagem()
                            }
                        }

                    case .failure(let err):
                        self?.mensagem = err.localizedDescription
                        self?.apresentaFeedback = true
                    }
                }
            }
            isLoading = false
        }
    }
    
    //MARK: Métodos validadores
    func nomeValido(){
        if ong.nome.isEmpty || ong.nome == ""{
            mensagem = "Parece que você não colocou um nome para a ONG :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func cnpjValido(){
        let cnpjTest = NSPredicate(format: "SELF MATCHES %@",
                                    "[0-9]{2}\\.?[0-9]{3}\\.?[0-9]{3}\\/?[0-9]{4}\\-?[0-9]{2}")
        ong.cnpj = ong.cnpj.replacingOccurrences(of: " ", with: "")
        if !cnpjTest.evaluate(with: ong.cnpj){
            mensagem = "Parece que cnpj não está no formato correto :)\nExemplo: 12.345.567/0001-89"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func descricaoValido(){
        if ong.descricao.isEmpty || ong.nome == ""{
            mensagem = "Parece que você não colocou uma descrição para a ONG :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func cepValido(){
        let cepTest = NSPredicate(format: "SELF MATCHES %@",
                                    "[0-9]{5}\\-?[0-9]{3}")
        ong.endereco.cep = ong.endereco.cep.replacingOccurrences(of: " ", with: "")
        if !cepTest.evaluate(with: ong.endereco.cep){
            mensagem = "Parece que o cep não está no formato correto :)\nExemplo: 12345-678"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func ruaValido(){
        if ong.endereco.logradouro.isEmpty || ong.endereco.logradouro == ""{
            mensagem = "Parece que você não colocou a rua da ONG :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func numValido(){
        if ong.endereco.numero.isEmpty || ong.endereco.numero == ""{
            mensagem = "Parece que você não colocou o número da ONG :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func estadoValido(){
        let estadoTest = NSPredicate(format: "SELF MATCHES %@",
                                    "[A-Z]{2}")
        if !estadoTest.evaluate(with: ong.endereco.estado){
            mensagem = "Parece que o estado não está no formato correto :)\nExemplo: SP"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func bairroValido(){
        if ong.endereco.bairro.isEmpty || ong.endereco.bairro == ""{
            mensagem = "Parece que você não colocou o bairro da ONG :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func cidadeValido(){
        if ong.endereco.cidade.isEmpty || ong.endereco.cidade == ""{
            mensagem = "Parece que você não colocou a cidade da ONG :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func telefoneValido(){
        let telefoneTest = NSPredicate(format: "SELF MATCHES %@",
                                    "\\(?[0-9]{2}\\)?[0-9]?[0-9]{4}\\-?[0-9]{4}")
        ong.telefone = ong.telefone.replacingOccurrences(of: " ", with: "")
        if !telefoneTest.evaluate(with: ong.telefone){
            mensagem = "Parece que o telefone não está no formato correto :)\nExemplo: (11)94002-8922"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func emailValido(){
        // criteria in regex.  See http://regexlib.com
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        ong.email = ong.email.replacingOccurrences(of: " ", with: "")
        if !emailTest.evaluate(with: ong.email){
            mensagem = "Parece que o e-mail não está no formato correto :)\nExemplo: nome@email.org.br"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func bancoValido(){
        if ong.banco.banco.isEmpty || ong.banco.banco == ""{
            mensagem = "Parece que você não colocou o nome do banco da ONG :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func agenciaValido(){
        let agenciaTest = NSPredicate(format: "SELF MATCHES %@",
                                    "[0-9]{4}")
        ong.banco.agencia = ong.banco.agencia.replacingOccurrences(of: " ", with: "")
        if !agenciaTest.evaluate(with: ong.banco.agencia){
            mensagem = "Parece que a agência não está no formato correto :)\nExemplo: 0001"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func contaValido(){
        let contaTest = NSPredicate(format: "SELF MATCHES %@",
                                    "[0-9]{5}\\-?[0-9]")
        ong.banco.conta = ong.banco.conta.replacingOccurrences(of: " ", with: "")
        if !contaTest.evaluate(with: ong.banco.conta){
            mensagem = "Parece que a conta não está no formato correto :)\nExemplo: 12345-6"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func pixValido(){
        if ong.banco.pix.isEmpty || ong.banco.pix == ""{
            mensagem = "Parece que você não colocou o pix da ONG :)"
            apresentaFeedback = true
            cor = .red
        }
    }
    
    func verificaCampos(){
        apresentaFeedback = false
        
        pixValido()
        contaValido()
        agenciaValido()
        bancoValido()
        
        emailValido()
        telefoneValido()
        
        cidadeValido()
        bairroValido()
        estadoValido()
        numValido()
        ruaValido()
        cepValido()
        
        descricaoValido()
        cnpjValido()
        nomeValido()
        
        print(apresentaFeedback)
        print(mensagem)
    }
    
    
}

extension OngFormViewModel {
    enum Modo {
        case cadastro
        case perfil
    }
}

protocol OngFormViewModelDelegate: AnyObject {
    func atualizarHome()
    func atualizarHomeComImagem()
}
