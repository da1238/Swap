//
//  AccountTableViewController.swift
//  Swap
//
//  Created by David Abraham on 2/24/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage

class AccountTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtBio: UITextView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var photoActivityIndicator: UIActivityIndicatorView!
    
    //MARK: Variables
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    var imagePicker = UIImagePickerController()
    let numberOfRowsAtSection: [Int] = [4, 1, 1]
    var selectedImage: UIImage?


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoActivityIndicator.startAnimating()
        
        // Profile Picture customization
        profilePicture.contentMode = UIViewContentMode.scaleAspectFit
        profilePicture.layer.cornerRadius = 50
        profilePicture.layer.masksToBounds = true
        
        // Navigation Bar customization
        navigationController!.navigationBar.prefersLargeTitles = true
        

        setupProfile()
        let user = Auth.auth().currentUser
        if let user = user {
            
            let emailtext = user.email
            txtEmail.placeholder = emailtext
        
    }
        
        // Dismiss keyboard
        self.tableView.keyboardDismissMode = .onDrag
        
}
    func setupProfile(){
        
        if let uid = Auth.auth().currentUser?.uid{
            
            let storageRef = Storage.storage().reference().child("profile_picture").child(uid)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                let pic = UIImage(data: data!)
                self.profilePicture.image = pic
                self.photoActivityIndicator.stopAnimating()
            }
            databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    self.txtFirstName.placeholder = dict["first_name"] as? String
                    self.txtLastName.placeholder = dict["last_name"] as? String
                    self.txtUsername.placeholder = dict["username"] as? String
                    self.txtBio.text = dict["bio"] as? String
                }
            })
            
        }
    }

    @IBAction func btnLogout(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            if Auth.auth().currentUser != nil{
                do{
                    try? Auth.auth().signOut()
                    
                    if Auth.auth().currentUser == nil {
                        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
                        self.present(loginVC, animated: true, completion: nil)
                    }
                }
            }
        }))
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnEditPicture(_ sender: Any) {
        
        // Create Action sheet
        
        let actionSheet = UIAlertController(title:"Profile Picture", message:"Select", preferredStyle: UIAlertControllerStyle.actionSheet)
       
        let photoGallery = UIAlertAction(title: "Open Camera Roll", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        
        let camera = UIAlertAction(title: "Take New", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }

        actionSheet.addAction(photoGallery)
        actionSheet.addAction(camera)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func dismissFullScreenImage(sender: UITapGestureRecognizer){
        sender.view?.removeFromSuperview()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            profilePicture.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnDone(_ sender: Any) {
        
        guard let bio = self.txtBio.text else{
            print("email error")
            return
        }
        
        guard let email = self.txtEmail.text else{
            print("username error")
            return
        }
        guard let lastName = self.txtLastName.text else{
            print("username error")
            return
        }
        guard let firstName = self.txtFirstName.text else{
            print("username error")
            return
        }
        guard let username = self.txtUsername.text else{
            print("username error")
            return
        }

        let uid = Auth.auth().currentUser?.uid
        let storageRef = Storage.storage().reference().child("profile_picture").child(uid!)
        let userReference = self.databaseRef.child("users").child(uid!)
        


        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }

   
}
