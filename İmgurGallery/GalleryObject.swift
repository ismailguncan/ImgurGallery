//
//  GalleryObject.swift
//  İmgurGallery
//
//  Created by İsmail Güncan on 09/07/2017.
//  Copyright © 2017 İsmail Güncan. All rights reserved.
//

import UIKit
import SwiftyJSON

class GalleryObject: NSObject {
    
    var link: String
    var descript: String
    var privacy: String
    
    
    init(json : JSON) {
        link = json["link"].stringValue
        descript = json["description"].stringValue
        privacy = json["privacy"].stringValue
        
    }
    
    init(coder : NSCoder ) {
        link = coder.decodeObject(forKey: "link") as! String
        descript = coder.decodeObject(forKey: "descript") as! String
        privacy = coder.decodeObject(forKey: "privacy") as! String
    }
    
    func encodeWithCoder (encoder : NSCoder) {
        encoder.encode(link, forKey: "link")
        encoder.encode(descript, forKey: "descript")
        encoder.encode(privacy, forKey: "privacy")
    }
}
