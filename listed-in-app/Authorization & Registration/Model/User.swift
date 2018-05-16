//
//  User.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 12.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import Alamofire
import FacebookCore
import ObjectMapper
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import Reachability

struct User: Mappable, Codable {
    var userID = ""
    var fullName = ""
    var email = ""
    var photoURL: URL?
//    var providers: [String] = []
//    var userSettings = UserSettings.defaultSettings
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        userID <- map["uid"]
        fullName <- map["full_name"]
        email <- map["email"]
        photoURL <- (map["photoURL"], URLTransform(shouldEncodeURLString: false))
    }
    
    // авторизация через facebook
    static func authorizeViaFacebook(_ accessToken: AccessToken,
                                     completion: @escaping (User?, Message?) -> Void) {
        let token = accessToken.authenticationToken
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
        firebaseAuth(credential, completion: completion)
    }
    
    // авторизация через Google
    static func authorizeViaGoogle(_ googlePlusUser: GIDGoogleUser,
                                   completion: @escaping (User?, Message?) -> Void) {
        guard Reachability()!.isReachable else {
            completion(nil, .noInternetConnection)
            return
        }
        guard let authentication = googlePlusUser.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        firebaseAuth(credential, completion: completion)
    }
    
    
    // авторизация через email
    static func authorizeViaEmail(_ email: String, password: String, completion: @escaping (User?, Message?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (firebaseUser, error) in
            guard let firebaseUser = firebaseUser else {
                completion(nil, .custom(error!.localizedDescription))
                return
            }
            
            jsonify(firebaseUser.user, completion: completion)
        }
        
    }
    
    // Общая Firebase авторизация
    private static func firebaseAuth(_ credential: AuthCredential,
                                     completion: @escaping (User?, Message?) -> Void) {
        Auth.auth().signInAndRetrieveData(with: credential) { (firebaseUser, error) in
            guard let firebaseUser = firebaseUser else {
                completion(nil, .custom(error!.localizedDescription))
                return
            }
            
            jsonify(firebaseUser.user, completion: completion)
        }
    }
    
    
    // Регистрация пользователя
    static func registerUser(_ email: String,
                             password: String,
                             fullname: String,
                             completion: @escaping (User?, Message?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (firebaseUser, error) in
            guard let _ = firebaseUser else {
                completion(nil, .custom(error!.localizedDescription))
                return
            }
            
            updateWithName(fullname, completion: completion)
        }
    }
    
    static func logOut(completion: @escaping (Message?) -> Void) {
        let firebaseSignOut = Auth.auth()
        do {
            try firebaseSignOut.signOut()
            completion(nil)
        } catch {
            completion(.logoutError)
        }
    }
    
    
    // добавление имени пользователя
    static func updateWithName(_ fullname: String,
                               completion: @escaping (User?, Message?) -> Void) {
        if let user = Auth.auth().currentUser {
            let changeRequest = user.createProfileChangeRequest()
            
            changeRequest.displayName = fullname
            
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(nil, .custom(error.localizedDescription))
                } else {
                    jsonify(user, completion: completion)
                }
            }
        }
    }
    
    // JSON Method
    static func jsonify(_ firebaseUser: FirebaseAuth.User,
                        completion: @escaping (User?, Message?) -> Void) {
        var json: [String: Any] = ["uid": firebaseUser.uid,
                                   "providers": ["firebase"]]
        
        if let fullName = firebaseUser.displayName { json["full_name"] = fullName }
        if let email = firebaseUser.email { json["email"] = email }
        if let photoURL = firebaseUser.photoURL { json["photoURL"] = photoURL }
//        Storage.loggedIn = true
        completion(User(JSON: json)!, nil)
    }
    
    // загрузить аватарку пользователя на сервер
    static func update(avatar image: UIImage,
                       completion: @escaping (User?, Message?) -> Void) {
        
    }
    
    static func setUserInDictionary(_ user: User) -> [String: Any] {
        var json: [String: Any] = [:]
        
        json["name"] = user.fullName
        json["email"] = user.email
        json["imageURL"] = user.photoURL?.absoluteString ?? ""
//        json["providers"] = user.providers
        
        return json
    }
    
    static func writeUserInDatabase(_ user: [String: Any], userID: String) {
        // main references
        let rootRef = Database.database().reference()
        let itemsRef = rootRef.child("main")
        let usersRef = itemsRef.child("users")
        
        // child references
        let userRef = usersRef.child(userID)
        userRef.setValue(user)
    }
    
    
}
