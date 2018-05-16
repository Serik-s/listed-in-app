//
//  RegistrationViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 12.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit
import MKDropdownMenu
import GoogleSignIn
import Firebase
import FacebookLogin


class RegistrationViewController: ViewController {

    @IBOutlet weak var registerBackground: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: AttributedButton!
    
    
    private func configureGooglePlus() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    private func configureDropDown() {
        let dropdown = MKDropdownMenu.init(frame: CGRect(x: 0, y: 0, width: 320, height: 4))
        dropdown.dataSource = self as? MKDropdownMenuDataSource
        dropdown.delegate = self as? MKDropdownMenuDelegate
        self.view.addSubview(dropdown)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDropDown()
        configureGooglePlus()
        registerBackground.backgroundColor = UIColor(patternImage: UIImage(named: "authorization_background")!)
        // Do any additional setup after loading the view.
    }

    @IBAction func authorizeViaFacebook() {
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
            
            guard let user = user else {
                self.showAlert(with: .error, message: error)
                return
            }
            
            if let window = UIApplication.shared.windows.first {
//                user.providers.append("password")
                
                appStorage.user = user
                let jsonUser = User.setUserInDictionary(user)
                User.writeUserInDatabase(jsonUser, userID: user.userID)
                window.rootViewController = Storyboard.authorizationController
            }
        }
        
    }
}


// Extension with protocol GOOGLE SIGN IN DELEGATE
extension RegistrationViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        self.startAnimating()
        
        User.authorizeViaGoogle(user) { user, error in
            self.stopAnimating()
            
            guard let user = user else {
                self.showAlert(with: .error, message: error)
                return
            }
            
            if let window = UIApplication.shared.windows.first {
//                user.providers.append("google.com")
                
                appStorage.user = user
//                let jsonUser = User.setUserInDictionary(user)
//                User.writeUserInDatabase(jsonUser, userID: user.userID)
                window.rootViewController = Storyboard.authorizationController
            }
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
