//
//  ImageStorageService.swift
//  Mini4
//
//  Created by Beatriz Sato on 14/10/21.
//

import Foundation
import Firebase
import FirebaseStorage

class ImageStorageService {
    static var shared: ImageStorageService = {
        let instance = ImageStorageService()
        return instance
    }()
    
    private let storageReference = Storage.storage().reference()
    
    private init() { } 
    
    func uploadImage(idOng: String, image: UIImage, completion: @escaping (String, Error?) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        let storageMetadata = StorageMetadata()
        storageMetadata.contentType = "image/jpeg"
        
        // salva imagem
        storageReference.child(idOng).putData(imageData, metadata: storageMetadata) { _ , err in
            if let err = err {
                completion("", err)
                return
            }
            
            // pega url da imagem recém salva
            self.storageReference.child(idOng).downloadURL { url, error in
                if let error = error {
                    print(error)
                    completion("", error)
                }
                
                if let url = url {
                    let urlString = url.absoluteString
                    
                    completion(urlString, nil)
                }
            }
        }
    }
    
    func downloadImage(urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            URLSession.shared.dataTask(with: url) { data, res, error  in
                if let error = error {
                    completion(nil, error)
                }
                
                if let data = data, let image = UIImage(data: data) {
                    completion(image, nil)
                }
            }.resume()
        }
    }
}
