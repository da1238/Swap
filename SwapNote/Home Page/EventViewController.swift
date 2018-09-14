//
//  HomeViewController.swift
//  SwapNote
//
//  Created by David Abraham on 5/27/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var EventCollectionView: UICollectionView!
    @IBOutlet weak var GroupCollectionView: UICollectionView!
    
    //MARK: Variables
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    var noPic: UIImage!
    var imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

    let eventName = ["ASU Meeting", "ASA Meeting", "Broadway Excursion"]
    let eventImage = [#imageLiteral(resourceName: "Art"), #imageLiteral(resourceName: "Sustainability"), #imageLiteral(resourceName: "Communication")]
    let eventDescription = ["ASU Meeting every other Wednesday from 5:30pm to 6:30pm.", "ASA Meetings every now and then, not sure when.", "$50 dollars to go to Broadway in New York with SAB."]
    
    let groupName = ["SAB", "Minds Matter", "ASA", "Pulse","The Bridge", "BSU", "SGA"]
    let groupImage = [#imageLiteral(resourceName: "SAB"), #imageLiteral(resourceName: "MindsMatter"), #imageLiteral(resourceName: "ASA"), #imageLiteral(resourceName: "Pulse"),#imageLiteral(resourceName: "TheBridge"),#imageLiteral(resourceName: "BSU"),#imageLiteral(resourceName: "SGA")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Invisible Nav bar
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        EventCollectionView.delegate = self
        GroupCollectionView.delegate = self
        
        EventCollectionView.dataSource = self
        GroupCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.EventCollectionView {
        return eventName.count
        }
        else{
            return groupName.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.EventCollectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! EventCollectionViewCell
        
        cell.eventTitle.text = eventName[indexPath.row]
        cell.eventImage.image = eventImage[indexPath.row]
        cell.eventDescription.text = eventDescription[indexPath.row]
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
        } else{
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCollectionViewCell
            cellB.GroupImage.image = groupImage[indexPath.row]
                        
            return cellB
        }
    
    }
}
