//
//  CustomImageView.swift
//  İmgurGallery
//
//  Created by İsmail Güncan on 14/07/2017.
//  Copyright © 2017 İsmail Güncan. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String? = nil
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleToFill) {
        contentMode = mode

        imageUrlString = link
        
        let h = UIScreen.main.bounds.height
        if h < 665 {
            activityIndicator.center = CGPoint(x: center.x + 47.5, y: center.y - 70)
        } else {
            activityIndicator.center = CGPoint(x: center.x, y: center.y - 70)
        }
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        guard let url = URL(string: link) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: link as AnyObject) as? UIImage {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
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
                    self.activityIndicator.stopAnimating()
                }
                if imageToCache != nil {
                    imageCache.setObject(imageToCache!, forKey: link as AnyObject)
                }
            }
            }.resume()
        
    }
}
