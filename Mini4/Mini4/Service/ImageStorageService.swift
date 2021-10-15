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
    
    func uploadImage(orgName: String, image: UIImage, completion: @escaping (String, Error?) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        let storageMetadata = StorageMetadata()
        storageMetadata.contentType = "image/jpeg"
        
        // salva imagem
        storageReference.child(orgName).putData(imageData, metadata: storageMetadata) { _ , err in
            if let err = err {
                completion("", err)
                return
            }
            
            // pega url da imagem recém salva
            self.storageReference.child(orgName).downloadURL { url, error in
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
}
