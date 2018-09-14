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
import FBSDKLoginKit
import GoogleSignIn
import Alamofire
import StatusAlert


class AccountTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: Properties
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMajor: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtCollege: UITextField!
    @IBOutlet weak var photoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    //MARK: Variables
    let databaseRef = Database.database().reference()
    var imagePicker = UIImagePickerController()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    let numberOfRowsAtSection: [Int] = [6, 2, 1]
    var profileImageUrl: String!
    var selectedImage: UIImage?
    var noPic: UIImage!
    var userRating: String!
    let saveAlert = StatusAlert.instantiate(withImage: #imageLiteral(resourceName: "tickIcon"), title: "Saved", message: "", canBePickedOrDismissed: true)
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoActivityIndicator.startAnimating()
        
        // Profile Picture customization
        profilePicture.contentMode = UIViewContentMode.scaleAspectFit
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor(red:0.00, green:0.80, blue:0.61, alpha:1.0).cgColor

        setupProfile()

        // Dismiss keyboard
        self.tableView.keyboardDismissMode = .onDrag
        
}
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //MARK: Private functions

    func setupProfile(){
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            let emailtext = user.email
            txtEmail.placeholder = emailtext
        }
        
        if let uid = Auth.auth().currentUser?.uid{
            
            let storageRef = Storage.storage().reference().child("profile_picture").child(uid)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (data == nil) {
                    self.profilePicture.image = self.noPic
                }
                else {
                let pic = UIImage(data: data!)
                self.profilePicture.image = pic
                self.photoActivityIndicator.stopAnimating()
                }
            }
            databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    self.txtFirstName.text = dict["first_name"] as? String
                    self.txtLastName.text = dict["last_name"] as? String
                    self.txtUsername.text = dict["username"] as? String
                    self.txtMajor.text = dict["major"] as? String
                    self.txtCollege.text = dict["college"] as? String
                    self.txtYear.text = dict["year"] as? String
                    self.txtPhoneNumber.text = dict["phone"] as? String
                    self.userRating = dict["user_rating"] as? String
                }
            })
            
        }
    }

    @IBAction func btnLogout(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: .alert)
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
            if Auth.auth().currentUser != nil{
                do{
                    try? Auth.auth().signOut()
                    GIDSignIn.sharedInstance().signOut()
                    FBSDKLoginManager().logOut()
                    if Auth.auth().currentUser == nil {
                        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! LoginViewController
                        self.present(loginVC, animated: true, completion: nil)
                    }
                }
            }
        }))
        confirmationAlert.title = nil
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnEditPicture(_ sender: Any) {
        
        //Create action sheet
        let actionSheet = UIAlertController(title:"Upload Picture", message:"Select Picture", preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.title = nil
        actionSheet.message = nil
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let image = selectedImageFromPicker{
            selectedImage = image
            profilePicture.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDone(_ sender: Any) {
        
        // Activity Indicator
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        guard let firstName = self.txtFirstName.text else {return}
        guard let lastName = self.txtLastName.text else {return}
        guard let username = self.txtUsername.text else {return}
        guard let major = self.txtMajor.text else {return}
        guard let college = self.txtCollege.text else {return}
        guard let year = self.txtYear.text else {return}
        guard let phone = self.txtPhoneNumber.text else {return}
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let storageRef = Storage.storage().reference().child("profile_picture").child(uid!)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1){
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    return
                }
                self.profileImageUrl = metadata?.downloadURL()?.absoluteString
                })
            }
        let userReference = self.databaseRef.child("users").child(uid!)
        let values = ["first_name": firstName,
                      "last_name": lastName,
                      "email": user?.email,
                      "username": username,
                      "major": major,
                      "college": college,
                      "year": year,
                      "phone": phone,
                      "user_photo": self.profileImageUrl,
                      "user_rating": self.userRating]
        
        userReference.updateChildValues(values, withCompletionBlock: {(error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.activityIndicator.stopAnimating()
            self.saveAlert.showInKeyWindow()

        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
