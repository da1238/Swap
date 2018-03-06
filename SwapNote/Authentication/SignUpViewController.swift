//
//  SignUpViewController.swift
//  SwapNote
//
//  Created by David Abraham on 12/11/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: Variables
    let databaseRef = Database.database().reference()
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    
    //MARK: Properties
    @IBOutlet weak var signUpForm: UIScrollView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userPhoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Invisible Nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // No Text on back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Hide keyboard on Done
        self.password.delegate = self
        self.email.delegate = self
        self.username.delegate = self
        self.confirmPassword.delegate = self
        
        // Sign Up form
        username.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        
        //Customize button
        signUpButton.layer.cornerRadius = 15
        
        //  User photo
        userPhoto.contentMode = UIViewContentMode.scaleAspectFit
        userPhoto.layer.cornerRadius = 45
        userPhoto.layer.masksToBounds = true
        
        
    }
    
    //MARK: Actions

    @IBAction func uploadPicture(_ sender: UITapGestureRecognizer) {
        
        //Create action sheet
        let actionSheet = UIAlertController(title:"Upload Picture", message:"Select Picture", preferredStyle: UIAlertControllerStyle.actionSheet)
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
        
        if let image = selectedImageFromPicker{
            selectedImage = image
            userPhoto.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // Customize text fields
    override func viewDidLayoutSubviews() {
        
        let lineColor = UIColor.lightGray
        self.username.setBottomLine(borderColor: lineColor)
        self.password.setBottomLine(borderColor: lineColor)
        self.confirmPassword.setBottomLine(borderColor: lineColor)
        self.email.setBottomLine(borderColor: lineColor)
        
    }
    
    
    // Cancel Button
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Sign Up
    
    @IBAction func signUp(_ sender: Any) {
        if confirmPassword.text == password.text{
            Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: {(user, error) in
                if error != nil{
                    let signuperrorAlert = UIAlertController(title: "Sign Up Error", message: "\(String(describing: error!.localizedDescription)) Please try again.", preferredStyle: .alert)
                    signuperrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(signuperrorAlert, animated: true, completion: nil)
                    return
                }
                
                guard let email = self.email.text else{
                    print("email error")
                    return
                }

                guard let username = self.username.text else{
                    print("username error")
                    return
                }
                
                let uid = user?.uid
                let storageRef = Storage.storage().reference().child("profile_picture").child(uid!)
                if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1){
                    storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                        if error != nil{
                            return
                        }
                        let profileImageUrl = metadata?.downloadURL()?.absoluteString
                        let userReference = self.databaseRef.child("users").child(uid!)
                        let values = ["first_name": "N/A", "last_name": "N/A", "email": email, "username": username, "bio": "N/A", "user_photo": profileImageUrl, "user_rating": "0.0"]
                        
                        userReference.updateChildValues(values, withCompletionBlock: {(error, ref) in
                            if error != nil {
                                print(error!)
                                return
                            }
                        })
                    })
                } else {
                    let passwordnomatchAlert = UIAlertController(title: "Error", message: "Passwords do not match. Please try again.", preferredStyle: .alert)
                    passwordnomatchAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                        self.password.text = ""
                        self.confirmPassword.text = ""
                    }))
                    self.present(passwordnomatchAlert, animated: true, completion: nil)
                }
                    })
                }

        self.sendEmail()
        

    }
    
    
    func sendEmail() {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error != nil {
                print("Error: \(String(describing:error!.localizedDescription))")
                return
            }
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                if error != nil {
                    let emailNOTSentAlert = UIAlertController(title: "Email Verification", message: "Email Failed to send: \(String(describing: error!.localizedDescription))", preferredStyle: .alert)
                    emailNOTSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(emailNOTSentAlert, animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
    
                    let emailSentAlert = UIAlertController(title: "Email Verification", message: "A verification email has been sent to your inbox.", preferredStyle: .alert)
                    emailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:{(action) in
                        self.dismiss(animated: true, completion: nil)
                    }))

                    self.present(emailSentAlert, animated: true, completion: nil)
                }
                do {
                    try Auth.auth().signOut()
                } catch {
                    // error handling
                }
                
            })
        }
    }
    
    
    // Hide Keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        username.resignFirstResponder()
        confirmPassword.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == username{
            email.becomeFirstResponder()
        }else if textField == email{
            password.becomeFirstResponder()
        } else if textField == password{
            confirmPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag{
        case 0...1:
            print("Do nothing")
        
        default:
            signUpForm.setContentOffset(CGPoint(x: 0,y: 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        signUpForm.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// Text field customization
extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
}


