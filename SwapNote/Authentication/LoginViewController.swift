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
import GoogleSignIn
import FirebaseDatabase
import Firebase
import FirebaseCore
import FBSDKCoreKit
import GoogleSignIn


class LoginViewController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate, LoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate{
    
    //MARK: Variables
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var databaseRef: DatabaseReference!
    var dict : [String : AnyObject]!
    
    
    //MARK: Properties
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        // Hide keyboard on Done
        self.password.delegate = self;
        self.email.delegate = self;
        
        // Log in form
        password.delegate = self
        email.delegate = self
        
        // Login button Customize
        logInBtn.layer.cornerRadius = logInBtn.frame.size.height/2
        logInBtn.layer.borderWidth = 2
        logInBtn.layer.borderColor = UIColor(red:0.00, green:0.80, blue:0.61, alpha:1.0).cgColor
        
        // Facebook Login Button
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.frame = CGRect(x: 95, y: 535, width: 192, height: 35)
        view.addSubview(loginButton)
        loginButton.delegate = self as LoginButtonDelegate
        
        // Google Button Customize
        signInButton.style = GIDSignInButtonStyle.wide
        
        
    }
    
    // White Status Bar Font
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Google Auth
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // Activity Indicator
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if error == nil {
            print(error)
        } else {
            print("User created")
            self.activityIndicator.stopAnimating()
        }
        
        
        guard let authentication = user?.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print(error!)
            }
            
            // User is signed in
            self.databaseRef = Database.database().reference()
            self.databaseRef.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let snapshot = snapshot.value as? NSDictionary
                if(snapshot == nil){
                    
                    self.databaseRef.child("users").child(user!.uid).child("first_name").setValue(user?.displayName)
                    self.databaseRef.child("users").child(user!.uid).child("last_name").setValue("")
                    self.databaseRef.child("users").child(user!.uid).child("email").setValue(user?.email)
                    self.databaseRef.child("users").child(user!.uid).child("username").setValue("floridaman")
                    self.databaseRef.child("users").child(user!.uid).child("major").setValue("Unspecified Major")
                    self.databaseRef.child("users").child(user!.uid).child("college").setValue("Messiah College")
                    self.databaseRef.child("users").child(user!.uid).child("user_photo").setValue("")
                    self.databaseRef.child("users").child(user!.uid).child("user_rating").setValue("0.0")
                    self.databaseRef.child("users").child(user!.uid).child("phone").setValue("(000)-000-000")
                    
                }
            })
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "signIn", sender: self)
        })
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            print(error)
        }
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //Facebook Auth
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        // Activity Indicator
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        
        switch result {
        case .success:
            self.activityIndicator.startAnimating()
            let accessToken = AccessToken.current
            guard let accessTokenString = accessToken?.authenticationToken else { return }
            
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                if error != nil{
                    print(error!)
                    return
                }
                
                // User is signed in
                self.databaseRef = Database.database().reference()
                self.databaseRef.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let snapshot = snapshot.value as? NSDictionary
                    if(snapshot == nil){
                        if((FBSDKAccessToken.current()) != nil) {
                            
                            FBSDKGraphRequest(graphPath: "me",
                                              parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email , gender"]).start(completionHandler: { (connection, result, error) -> Void in
                                                if (error == nil) {
                                                    self.dict = result as! [String : AnyObject]
                                                    let firstName = self.dict["first_name"] as? String
                                                    let lastName = self.dict["last_name"] as? String
                                                    let profilePicture = self.dict["picture.type(large)"] as? String
                                                    let email = self.dict["email"] as? String
                                                    
                                                    self.databaseRef.child("users").child(user!.uid).child("first_name").setValue(firstName)
                                                    self.databaseRef.child("users").child(user!.uid).child("last_name").setValue(lastName)
                                                    self.databaseRef.child("users").child(user!.uid).child("email").setValue(email)
                                                    self.databaseRef.child("users").child(user!.uid).child("username").setValue(firstName)
                                                    self.databaseRef.child("users").child(user!.uid).child("major").setValue("Unspecified Major")
                                                    self.databaseRef.child("users").child(user!.uid).child("college").setValue("Messiah College")
                                                    self.databaseRef.child("users").child(user!.uid).child("user_photo").setValue(profilePicture)
                                                    self.databaseRef.child("users").child(user!.uid).child("user_rating").setValue("0.0")
                                                    self.databaseRef.child("users").child(user!.uid).child("phone").setValue("(000)-000-000")
                                                    
                                                }})
                        }
                        
                    }
                })
                self.getFBUserData()
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "signIn", sender: self)
            })
        default:
            break
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me",
                              parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email , gender"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil) {
                                    self.dict = result as! [String : AnyObject]
                                    print(result!)
                                    print(self.dict)
                                    
                                }})
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Logged out of Facebook")
    }
    
    // Firebase Login
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}



