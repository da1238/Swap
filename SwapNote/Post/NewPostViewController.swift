//
//  NewPostViewController.swift
//  SwapNote
//
//  Created by David Abraham on 2/3/18.
//  Copyright © 2018 David Abraham. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class NewPostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var photoActivityIndicator: UIActivityIndicatorView!
    
    //MARK: Variables
    var pic: UIImage?
    var photoData: Data!
    
    // Database Reference
    var database = Firestore.firestore()
    let databaseRef = Database.database().reference()
    
    @IBOutlet weak var newPost: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPost.becomeFirstResponder()
        newPost.textContainerInset = UIEdgeInsetsMake(30, 20, 20, 20)
        if(newPost.text.count == 0) {
        newPost.text = "What's Up?"
        newPost.textColor = UIColor.lightGray
        }
        
        photoActivityIndicator.startAnimating()
        
        userProfilePic.contentMode = UIViewContentMode.scaleAspectFit
        userProfilePic.layer.cornerRadius = 25
        userProfilePic.layer.masksToBounds = true
        
         setupProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hide Keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        newPost.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(newPost.textColor == UIColor.lightGray){
            newPost.text = ""
            newPost.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(newPost.text.count == 0) {
            newPost.text = "What's Up?"
            newPost.textColor = UIColor.lightGray
        }
    }

    @IBAction func btnPost(_ sender: Any) {
        if(newPost.text.count != 0){
            
            if let uid = Auth.auth().currentUser?.uid{
                
                let storageRef = Storage.storage().reference().child("profile_picture").child(uid)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    self.pic = UIImage(data: data!)
                    self.photoData = data!
                }
                
                storageRef.getMetadata(completion: { (metadata, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
    
                    self.databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String: AnyObject]
                    {
                        let firstName = dict["first_name"] as? String
                        let lastName = dict["last_name"] as? String
                        let name = firstName! + " " + lastName!
                        let username = dict["username"] as? String
                        
                        let newPost = Post(photo: self.photoData, name: name, userName: username! , content: self.newPost.text, timeStamp: Date())
                        var ref:DocumentReference? = nil
                        ref = self.database.collection("posts").addDocument(data: newPost.dictionary){
                            error in
                            if let error = error{
                                print("Error adding doc: \(error.localizedDescription)")
                            }else{
                                print("Document added with ID: \(ref!.documentID)")
                            }
                        }
                        
                    }
                })
            })
            
        }
        dismiss(animated: true, completion: nil)
    }
    }
    
    // MARK: Functions
    func setupProfile(){

        if let uid = Auth.auth().currentUser?.uid{

            let storageRef = Storage.storage().reference().child("profile_picture").child(uid)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                let pic = UIImage(data: data!)
                self.userProfilePic.image = pic
                self.photoActivityIndicator.stopAnimating()
            }

            databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    let firstName = dict["first_name"] as? String
                    let lastName = dict["last_name"] as? String
                    self.lblName.text = firstName! + " " + lastName!
                    self.lblUsername.text = dict["username"] as? String
                }
            })
        }
    }

    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
