//
//  ViewController.swift
//  İmgurGallery
//
//  Created by İsmail Güncan on 09/07/2017.
//  Copyright © 2017 İsmail Güncan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    var objects: [GalleryObject]?
    var activityIndicator: NVActivityIndicatorView?
    
    var currentPage = 1;
    var defaultPath = "hot/top"
    var isViralShowing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        // For Iphone 5, grid view turn to list view.(1 column)
        let h = UIScreen.main.bounds.height
        if h < 665 {
            layout.itemSize = CGSize(width: 275,height: 250)
        } else {
            layout.itemSize = CGSize(width: 180,height: 250)
        }
        
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        
        Operations.getGalleryImages(path: defaultPath, page: currentPage, showViral: isViralShowing) { (galerryObjects) in
            self.objects = galerryObjects
            self.currentPage = self.currentPage + 1
            
            DispatchQueue.main.async(execute: self.refresh)
        }
    }
    
    @IBAction func selectSectionSegmentControlAction(_ sender: UISegmentedControl) {
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x-60, y: self.view.center.y-60, width: 120, height: 120))
        activityIndicator?.type = .pacman
        activityIndicator?.color = UIColor.orange
        
        if activityIndicator != nil {
            self.collectionView.alpha = 0.3
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
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
    
    //ShowViral parameters can use with section "USER", so I change the default path before changing the showViral parameters to get more images.
    @IBAction func showViralSwitchAction(_ sender: UISwitch) {
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x-60, y: self.view.center.y-60, width: 120, height: 120))
        activityIndicator?.type = .pacman
        activityIndicator?.color = UIColor.orange
        
        if activityIndicator != nil {
            self.collectionView.alpha = 0.3
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
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
    
    // MARK: Collection View 
    
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
        
        //to fetch more images while scrolling down.
        if let objects = objects, (indexPath.row == objects.count - 2) {
            if objects.count < 55 {
                fetchMoreImages()
            }
        }
        
        // Sometimes imgur return less than 5 items, so need to get more new items.
        if (objects?.count)! < 5 {
            fetchMoreImages()
        }
        
        let object = objects![indexPath.row]
        
        // download the image from URL and cache.
        cell.imageView.downloadedFrom(link: object.link)
        
        // Set image's description to label.
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
            if self.activityIndicator != nil {
                self.activityIndicator?.stopAnimating()
                self.collectionView.alpha = 1
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator = nil
            }
            DispatchQueue.main.async(execute: self.refresh)
        }
    }
    
}

