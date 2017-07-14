//
//  ViewController.swift
//  İmgurGallery
//
//  Created by İsmail Güncan on 09/07/2017.
//  Copyright © 2017 İsmail Güncan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    var objects: [GalleryObject]?
    
    var currentPage = 1;
    var defaultPath = "hot/top"
    var isViralShowing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        
//        let w = UIScreen.main.bounds.width
//        if w < 667 {
//            layout.itemSize = CGSize(width: 275,height: 225)
//        } else {
//            layout.itemSize = CGSize(width: 180,height: 180)
//        }
//        
//        self.collectionView.setCollectionViewLayout(layout, animated: true)
        
        Operations.getGalleryImages(path: defaultPath, page: currentPage, showViral: isViralShowing) { (galerryObjects) in
            self.objects = galerryObjects
            self.currentPage = self.currentPage + 1
            
            DispatchQueue.main.async(execute: self.refresh)
        }
    }
    
    @IBAction func selectSectionSegmentControlAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            defaultPath = "hot/all"
            objects?.removeAll()
            currentPage = 1
            fetchMoreImages()
        case 1:
            defaultPath = "top/all"
            objects?.removeAll()
            currentPage = 1
            fetchMoreImages()
        default:
            break
            
        }
    }
    
    @IBAction func showViralSwitchAction(_ sender: UISwitch) {
        defaultPath = "user/"
        if sender.isOn {
            isViralShowing = true
            objects?.removeAll()
            currentPage = 1
            fetchMoreImages()
        }
        else {
            isViralShowing = false
            objects?.removeAll()
            currentPage = 1
            fetchMoreImages()
        }
    }
    
    func refresh()
    {
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    // MARK: let w = UIScreen.mainScreen().bounds.width methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let objects = objects {
            return objects.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImgurCollectionViewCell
        
        if let objects = objects, (indexPath.row == objects.count - 2) {
            if objects.count < 55 {
                fetchMoreImages()
            }
        }
        
        if (objects?.count)! < 5 {
            fetchMoreImages()
        }
        
        let object = objects![indexPath.row]
        
        cell.imageView.downloadedFrom(link: object.link)
        
        if !object.descript.isEmpty {
            cell.descriptionLabel.text = object.descript
        } else {
            cell.descriptionLabel.text = "Title: \(object.title)"
        }
        
        return cell
    }
    
    func fetchMoreImages() {
        Operations.getGalleryImages(path: defaultPath, page: currentPage, showViral: isViralShowing) { (galerryObjects) in
            
            if galerryObjects.count > 0 {
                self.objects?.append(contentsOf: galerryObjects)
                self.currentPage = self.currentPage + 1
            }
            DispatchQueue.main.async(execute: self.refresh)
        }
    }
    
}

