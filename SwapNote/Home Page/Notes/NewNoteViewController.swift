//
//  NewNoteViewController.swift
//  SwapNote
//
//  Created by David Abraham on 12/11/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

class NewNoteViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: Variables
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var noteImageUrl: String?
    var photoData: Data!
    var pic: UIImage?
    
    
    // Database Reference
    var database = Firestore.firestore()
    let databaseRef = Database.database().reference()
    
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteInstructor: UITextField!
    @IBOutlet weak var noteDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Delete Button
    @IBAction func btnTrash(_ sender: Any) {
        //Create action sheet
        let actionSheet = UIAlertController(title:"Delete", message: "Are you sure you want to delete this note? All unsaved changes will be lost.", preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.title = nil
        
        let delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(delete)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    // Add button
    @IBAction func btnAdd(_ sender: Any) {
        //Create action sheet
        let actionSheet = UIAlertController(title:"", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.title = nil
        actionSheet.message = nil
        
        let scanDocuments = UIAlertAction(title: "Scan Documents", style: UIAlertActionStyle.default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }
        actionSheet.addAction(scanDocuments)
        actionSheet.addAction(photoLibrary)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // Camera
    @IBAction func btnCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }
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
            noteImage.image = image
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Cancel Button
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCreate(_ sender: Any) {
        
        if let uid = Auth.auth().currentUser?.uid{
            
            let storageRef = Storage.storage().reference().child("notes_picture").child(uid)
            if let noteImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(noteImg, 0.1){
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        return
                    }
                    self.noteImageUrl = metadata?.downloadURL()?.absoluteString
                })
            }
                self.databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String: AnyObject]
                    {
                        let firstName = dict["first_name"] as? String
                        let lastName = dict["last_name"] as? String
                        let name = firstName! + " " + lastName!
                        let newNote = Note(photo: "", owner: name, instructor: self.noteInstructor.text!, description: self.noteDescription.text, title: self.noteTitle.text!)
                        
                        var ref:DocumentReference? = nil
                        ref = self.database.collection("notes").addDocument(data: newNote.dictionary){
                            error in
                            if let error = error{
                                print("Error adding doc: \(error.localizedDescription)")
                            }else{
                                print("Document added with ID: \(ref!.documentID)")
                            }
                        }
                        
                    }
                })

        }
        dismiss(animated: true, completion: nil)
        }
    
    // Hide Keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        noteTitle.resignFirstResponder()

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
