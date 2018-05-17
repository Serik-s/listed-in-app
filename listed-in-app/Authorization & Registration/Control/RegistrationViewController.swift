//
//  RegistrationViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 12.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FacebookLogin


class RegistrationViewController: ViewController {

    @IBOutlet weak var registerBackground: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: AttributedButton!
    
    var isInvestor: Bool!
    
    
    private func configureGooglePlus() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGooglePlus()
        registerBackground.backgroundColor = UIColor(patternImage: UIImage(named: "authorization_background")!)
        
    }

    @IBAction func authorizeViaFacebook() {
        LoginManager().logIn(readPermissions: [.email, .publicProfile], viewController: self) { result in
            switch result {
            case .success(_, _, let accessToken):
                self.startAnimating()
                User.authorizeViaFacebook(accessToken) { user, error in
                    self.stopAnimating()
                    
                    guard var user = user else {
                        self.showAlert(with: .error, message: error)
                        return
                    }
//                    if let window = UIApplication.shared.windows.first {
                        //                        user.providers.append("facebook.com")
                        
                    appStorage.user = user
                    if self.isInvestor {
                        user.userType = "investor"
                    } else {
                        user.userType = "startup"
                    }
                    let jsonUser = User.setUserInDictionary(user)
                    User.writeUserInDatabase(jsonUser, userID: user.userID)
                    //                window.rootViewController = Storyboard.authorizationController
                    self.performSegue(withIdentifier: user.userType, sender: nil)
//                        window.rootViewController = Storyboard.authorizationController
//                    }
                }
            case .failed:
                self.showAlert(with: .error, message: .facebookAuthError)
            case .cancelled:
                break
            }
        }
    }
    
    @IBAction func authorizeViaGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func registerViaEmail() {
        let name = userNameTextField.text!
        let password = userPasswordTextField.text!
        let email = userEmailTextField.text!
//      let userType = Investor or Start-upper
        
        self.startAnimating()
        User.registerUser(email, password: password, fullname: name) { (user, error) in
            self.stopAnimating()
            
            guard var user = user else {
                self.showAlert(with: .error, message: error)
                return
            }
            
//            if let window = UIApplication.shared.windows.first {
//                user.providers.append("password")
                
                appStorage.user = user
                if self.isInvestor {
                    user.userType = "investor"
                } else {
                    user.userType = "startup"
                }
                let jsonUser = User.setUserInDictionary(user)
                User.writeUserInDatabase(jsonUser, userID: user.userID)
//                window.rootViewController = Storyboard.authorizationController
                self.performSegue(withIdentifier: user.userType, sender: nil)
//            }
        }
        
    }
}


// Extension with protocol GOOGLE SIGN IN DELEGATE
extension RegistrationViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        self.startAnimating()
        
        User.authorizeViaGoogle(user) { user, error in
            self.stopAnimating()
            
            guard var user = user else {
                self.showAlert(with: .error, message: error)
                return
            }
            
//            if let window = UIApplication.shared.windows.first {
//                user.providers.append("google.com")
                
                appStorage.user = user
                if self.isInvestor {
                    user.userType = "investor"
                } else {
                    user.userType = "startup"
                }
                let jsonUser = User.setUserInDictionary(user)
                User.writeUserInDatabase(jsonUser, userID: user.userID)
//                let jsonUser = User.setUserInDictionary(user)
//                User.writeUserInDatabase(jsonUser, userID: user.userID)
                self.performSegue(withIdentifier: user.userType, sender: nil)
            
//            }
        }
    }
    
}

// Extension with protocol GOOGLE SIGN IN UI DELEGATE
extension RegistrationViewController: GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
}
