//
//  Operations.swift
//  İmgurGallery
//
//  Created by İsmail Güncan on 09/07/2017.
//  Copyright © 2017 İsmail Güncan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Operations {
    
    static let baseURL = "https://api.imgur.com/3/gallery"
    static let defaultHeaders : [String : String] = [
        "Authorization": "Client-ID 854b8bf2685c250"
    ]
    
    static func getGalleryImages(path: String, page: Int?, showViral: Bool, callback: @escaping (_ galleryObjects : [GalleryObject]) -> ()) {
        
        Alamofire.request("\(baseURL)/\(path)/\(page ?? 1)?showViral=\(showViral)", method: .get, headers: defaultHeaders).responseJSON { response in
            
            if response.response?.statusCode == 200 {
                
                var galleryObjects: [GalleryObject] = []
                
                let data = JSON(data: response.data!)
                
                let dataD = data["data"].arrayValue
                
                for json in dataD {
                    if (json["link"].stringValue.range(of: ".jpg") != nil ){
                        let galleryObject = GalleryObject(json: json)
                        galleryObjects.append(galleryObject)
                    }
                }
                
                callback(galleryObjects)
                
            }
            
        }
    }
    
    static func getVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "No Version Info"
        }
        return version
    }
    
    static func getBuildNumber() -> String {
        guard let buildNum = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return "No Version Info"
        }
        return buildNum
    }
}
