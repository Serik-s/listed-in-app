//
//  PostServiceFireBase.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 18.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

//import Foundation
//import UIKit
//import FirebaseStorage
//
//
//struct PostServiceFireBase {
//    static func create(for image: UIImage,path: String, completion: @escaping (String?) -> ()) {
//        let filePath = path
//
//        let imageRef = Storage.storage().reference().child(filePath)
//        StorageServiceFireBase.uploadImage(image, at: imageRef) { (downloadURL) in
//            guard let downloadURL = downloadURL else {
//                print("Download url not found or error to upload")
//                return completion(nil)
//            }
//
//            completion(downloadURL.absoluteString)
//        }
//    }
//
//}
//

