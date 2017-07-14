//
//  CustomImageView.swift
//  İmgurGallery
//
//  Created by İsmail Güncan on 14/07/2017.
//  Copyright © 2017 İsmail Güncan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String? = nil
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        contentMode = mode

        imageUrlString = link
        
        guard let url = URL(string: link) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: link as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error ?? "error")
                return
            }
            
            DispatchQueue.main.async() { () -> Void in
                
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == link {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: link as AnyObject)
            }
            }.resume()
        
    }
}
