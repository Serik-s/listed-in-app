//
//  AppDelegate.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 12.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import IQKeyboardManagerSwift

// Names of Storyboards and Controllers
struct Storyboard {
    // storyboards
    static let authorizationAndRegistration = UIStoryboard(name: Constants.login, bundle: nil)
//    static let profile = UIStoryboard(name: Constants.profile, bundle: nil)
//    static let mainView = UIStoryboard(name: Constants.mainView, bundle: nil)
//    // controllers
    static var investorViewController : UIViewController {
        return authorizationAndRegistration.instantiateViewController(withIdentifier: Constants.mainInvestor)
    }
    
    static var startupViewController: UIViewController {
        return authorizationAndRegistration.instantiateViewController(withIdentifier: Constants.mainStartup)
    }
//
    static var authorizationController: UINavigationController {
        return authorizationAndRegistration.instantiateViewController(withIdentifier: Constants.login) as! UINavigationController
    }
//
//    static var profileController: UINavigationController {
//        return profile.instantiateViewController(withIdentifier: Constants.profileNC) as! UINavigationController
//    }
}

// константы
private struct Constants {
    // Storyboard names
    static let login = "Login"
//    static let profile = "Profile"
    static let mainView = "MainView"
    static let mainInvestor = "main_investor"
    static let mainStartup = "main_startup"
    // Controller names
    static let authorizationNC = "Authorization Navigation Controller"
//    static let wifiInfo = "WiFi Info Controller"
//    static let profileNC = "Profile Controller"
    
    static let tabBarTintColor = UIColor(hex: 0xFFFFFF)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // настройки Firebase
        FirebaseApp.configure()
        
        // facebook настройки
        FBSDKApplicationDelegate.sharedInstance().application(application,
                                                              didFinishLaunchingWithOptions: launchOptions)
        
        // Google+ настройки
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self as GIDSignInDelegate
        
        
        // настройки умной клавиатуры
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.enable = true
        keyboardManager.enableAutoToolbar = false
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.keyboardDistanceFromTextField = 90
        
        // настройки tab bar'а
        UITabBar.appearance().tintColor = Constants.tabBarTintColor
        
        
        // Override point for customization after application launch.
        if let user = Auth.auth().currentUser {
            
            if let userType = UserDefaults.standard.string(forKey: "userType") {
                if userType == "investor" {
                    let nav = UINavigationController(rootViewController: Storyboard.investorViewController)
                    self.window?.rootViewController = nav
                } else {
                    let nav = UINavigationController(rootViewController: Storyboard.startupViewController)
                    self.window?.rootViewController = nav
                }
            }else{
                window?.rootViewController = Storyboard.authorizationController
            }
//            User.getUsetType(user.uid) { userType, error in
//                guard let userType = userType else {
////                    window?.rootViewController = Storyboard.authorizationController
//                    return
//                }
//
//                if userType == "investor" {
//                    let nav = UINavigationController(rootViewController: Storyboard.investorViewController)
//                    self.window?.rootViewController = nav
//                } else {
//                    let nav = UINavigationController(rootViewController: Storyboard.startupViewController)
//                    self.window?.rootViewController = nav
//                }
//            }
            
//            let nav = UINavigationController(rootViewController: Storyboard.investorViewController)
//            window?.rootViewController = nav
            print("user id \(user.uid)")
        } else {
            window?.rootViewController = Storyboard.authorizationController
        }

        return true
    }
    
    // открывает страницу safari в приложении
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let facebook = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        let googlePlus = GIDSignIn.sharedInstance().handle(url,
                                                           sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                           annotation: [:])
        
        return facebook || googlePlus
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        print("Google sign delegate")
        print(user.profile)
        print(user)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

