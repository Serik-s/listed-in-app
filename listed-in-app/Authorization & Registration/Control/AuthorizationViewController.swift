//
//  AuthorizationViewController.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 12.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn

class AuthorizationViewController: ViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var userEmailOutlet: UITextField!
    @IBOutlet weak var userPasswordOutlet: UITextField!
    @IBOutlet weak var loginButton: AttributedButton!
    
    
    private func configureGooglePlus() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureGooglePlus()
        backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "authorization_background")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func emailAuthorization() {
        startAnimating()
        
        User.authorizeViaEmail(self.userEmailOutlet.text!, password: self.userPasswordOutlet.text!) { (user, error) in
            self.stopAnimating()
            
            guard let user = user else {
                self.showAlert(with: .error, message: error)
                return
            }
            
//            if let window = UIApplication.shared.windows.first {
            
            User.getUsetType(user.userID) { userType, error in
                guard let userType = userType else {
                    self.showAlert(with: .error, message: error)
                    return
                }
                print(userType)
                appStorage.user = user
                self.performSegue(withIdentifier: userType, sender: nil)
            }
//                appStorage.user = user
//                let jsonUser = User.setUserInDictionary(user)
//                User.writeUserInDatabase(jsonUser, userID: user.userID)
//                self.performSegue(withIdentifier: user.userType, sender: nil)
//            }
        }
    }
    
    
    @IBAction func googleAuthorization() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookAuthorization() {
        
        
        LoginManager().logIn(readPermissions: [.email, .publicProfile], viewController: self) { result in
            switch result {
            case .success(_, _, let accessToken):
                self.startAnimating()
                User.authorizeViaFacebook(accessToken) { user, error in
                    self.stopAnimating()

                    guard let user = user else {
                        self.showAlert(with: .error, message: error)
                        return
                    }
//                    if let window = UIApplication.shared.windows.first {
//                        user.providers.append("facebook.com")

                    appStorage.user = user
                    let jsonUser = User.setUserInDictionary(user)
                    User.writeUserInDatabase(jsonUser, userID: user.userID)
                    self.performSegue(withIdentifier: "investor", sender: nil)
//                        let jsonUser = User.setUserInDictionary(user)
//                        User.writeUserInDatabase(jsonUser, userID: user.userID)
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
    
    
    
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Extension with protocol GOOGLE SIGN IN DELEGATE
extension AuthorizationViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        self.startAnimating()
        
        User.authorizeViaGoogle(user) { user, error in
            self.stopAnimating()
            
            guard var user = user else {
                self.showAlert(with: .error, message: error)
                return
            }
            
            if let window = UIApplication.shared.windows.first {
                //                user.providers.append("google.com")
                
                appStorage.user = user
                user.userType = "investor"
                //                let jsonUser = User.setUserInDictionary(user)
                //                User.writeUserInDatabase(jsonUser, userID: user.userID)
                self.performSegue(withIdentifier: user.userType, sender: nil)
            }
        }
    }
    
}

// Extension with protocol GOOGLE SIGN IN UI DELEGATE
extension AuthorizationViewController: GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
}
