//
//  AboutViewController.swift
//  İmgurGallery
//
//  Created by İsmail Güncan on 15/07/2017.
//  Copyright © 2017 İsmail Güncan. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    
    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var appBuildTime: UILabel!
    @IBOutlet weak var appBuildNumber: UILabel!
    @IBOutlet weak var nameEmail: UILabel!
    
    var compileDate:Date {
        let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as? String ?? "Info.plist"
        if let infoPath = Bundle.main.path(forResource: bundleName, ofType: nil),
            let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath),
            let infoDate = infoAttr[FileAttributeKey.creationDate] as? Date {
            
            return infoDate
            
        }
        return Date()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameEmail.text = "İsmail Güncan & ismailguncan@gmail.com"
        appVersion.text = Operations.getVersion()
        appBuildNumber.text = Operations.getBuildNumber()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        appBuildTime.text = formatter.string(from: compileDate)
        
    }
}
