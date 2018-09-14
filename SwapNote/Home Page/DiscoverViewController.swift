//
//  DiscoverViewController.swift
//  SwapNote
//
//  Created by David Abraham on 5/27/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let discoverImage = [#imageLiteral(resourceName: "studyFest"), #imageLiteral(resourceName: "wildpink"), #imageLiteral(resourceName: "destressFest"), #imageLiteral(resourceName: "lunar")]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
        // Invisible Nav bar
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discoverImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DiscoverCollectionViewCell
        
        cell.discoverImage.image = discoverImage[indexPath.row]
        
        
        return cell
    }
    
}
