//
//  LoginViewController.swift
//  SwapNote
//
//  Created by David Abraham on 12/11/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import FacebookCore


class LoginViewController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate{
    
    //MARK: Variables
     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    //MARK: Properties
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide keyboard on Done
        self.password.delegate = self;
        self.email.delegate = self;
        
        // Log in form
        password.delegate = self
        email.delegate = self
        
        // Login button Customize
        logInBtn.layer.cornerRadius = 15
        
        // Facebook Login Button
 
    }
    
        //Any changes
    
    
    // Customize text fields
    override func viewDidLayoutSubviews() {
        
        let lineColor = UIColor.lightGray
        self.password.setBottomLine(borderColor: lineColor)
        self.email.setBottomLine(borderColor: lineColor)
        
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email{
            password.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    
    // Login
    @IBAction func logIn(_ sender: Any) {
        
        // Activity Indicator
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) {(user, error) in
            if error != nil {
                let loginerrorAlert = UIAlertController(title: "Log In Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                loginerrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(loginerrorAlert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                return
            }
            
            if user!.isEmailVerified{
                // sign in
                self.performSegue(withIdentifier: "signIn", sender: self)
                self.activityIndicator.stopAnimating()
            } else {
                let notverifiedAlert = UIAlertController(title: "Verification Error", message: "Please tap on the link sent to your email to verify your account.", preferredStyle: .alert)
                notverifiedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(notverifiedAlert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                do {
                    try Auth.auth().signOut()
                } catch{
                    // error handling
                }
            }
        }
    }
    
    // Forgot password
    @IBAction func forgotPassword(_ sender: Any) {
        
        let forgotpasswordAlert = UIAlertController(title: "Forgot Password?", message: "Please enter your e-mail address below. A resent link will be sent to your inbox.", preferredStyle: .alert)
        forgotpasswordAlert.addTextField{(textField) in
            textField.placeholder = "Email address"
        }
        self.present(forgotpasswordAlert, animated: true, completion: nil)
        forgotpasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotpasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: {(action) in
            let resetEmail = forgotpasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: {(error) in
                if error != nil {
                    let resetfailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error!.localizedDescription))", preferredStyle: .alert)
                    resetfailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetfailedAlert, animated: true, completion: nil)
                } else {
                    let resetemailsentAlert = UIAlertController(title: "Email Sent", message: "Email Sent", preferredStyle: .alert)
                    resetemailsentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetemailsentAlert, animated: true, completion: nil)
                }
            })
        }))
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



