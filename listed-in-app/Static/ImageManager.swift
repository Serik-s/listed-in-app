//
//  ImageManager.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 17.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import Alamofire
import AlamofireImage

struct ImageManager {
    static func downloadImage(from url: URL?,
                              completion: @escaping (UIImage) -> Void) {
        // проверяем интернет соединение
        
        // проверка на целостность ссылки на картинку
        let imageURL = url
        Alamofire.request(imageURL!).responseImage { response in
            switch response.result {
            case .success(let image):
                completion(image)
            case .failure(let error):
                print("\(String(describing: imageURL)): - \(error.localizedDescription)")
            }
        }
    }
}

