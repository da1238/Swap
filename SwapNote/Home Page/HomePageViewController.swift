//
//  HomePageViewController.swift
//  SwapNote
//
//  Created by David Abraham on 12/11/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage


class HomePageViewController: UIViewController {
    
    //MARK: Variables
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    
    // MARK: Properties
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserRating: UILabel!
    @IBOutlet weak var lblBio: UITextView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var photoActivityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        
        photoActivityIndicator.startAnimating()
       
        
        // Navigation Bar customization
        navigationController!.navigationBar.prefersLargeTitles = true
        // Invisible Nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // No Text on back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        

        userProfilePic.contentMode = UIViewContentMode.scaleAspectFit
        userProfilePic.layer.cornerRadius = 25
        userProfilePic.layer.masksToBounds = true
        userInfoView.layer.cornerRadius = 15

        
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        setupProfile()
    }
    
    // MARK: Actions
    
    // MARK: Functions
    func setupProfile(){
        
        if let uid = Auth.auth().currentUser?.uid{
            let storageRef = Storage.storage().reference().child("profile_picture").child(uid)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (data == nil) {
                    self.userProfilePic.image = #imageLiteral(resourceName: "UserIcon")
                }
                else {
                let pic = UIImage(data: data!)
                self.userProfilePic.image = pic
                self.photoActivityIndicator.stopAnimating()
                }
            }
            
            databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    let firstName = dict["first_name"] as? String
                    let lastName = dict["last_name"] as? String
                    self.lblUserRating.text = dict["user_rating"] as? String
                    self.lblBio.text = dict["bio"] as? String
                    self.lblName.text = firstName! + " " + lastName!
                    self.lblUserName.text = dict["username"] as? String
                }
            })
        }
    }
}
