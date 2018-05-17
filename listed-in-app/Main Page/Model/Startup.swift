//
//  Startup.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 17.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//


import ObjectMapper
import FirebaseDatabase

class Startup :  Mappable{
//    var startupID = ""
    var name = ""
    var description = ""
    var photoURL: URL?
    var owner = ""
    
//    init(name: String, description: String, photoURL: URL?) {
//        self.name = name
//        self.description = description
//        self.photoURL = photoURL
//    }
    
    init(name: String, description: String, photoURL: URL, owner: String?) {
        self.name = name
        self.description = description
        self.photoURL = photoURL
        self.owner = owner!
    }
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
//        startupID <- map["startupID"]
        name <- map["name"]
        description <- map["description"]
        photoURL <- map["photoURL"]
        owner <- map["owner"]
    }
    
    static func getStartupList(completion: @escaping ([Startup]?, Message?) -> Void) {
        let rootRef = Database.database().reference()
        let mainRef = rootRef.child("main")
        let startupRef = mainRef.child("startups")
        
        startupRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot)
            guard let allStartups = snapshot.value as? [String: [String: Any]] else {
                completion(nil, Message.custom("Not found startups"))
                return
            }
            
            
            var startupArray: [Startup] = []
            for (_, value) in allStartups {
                for(_, value) in value {
                    let json = value as! [String: Any]
                    print("printing json")
                    print(json)
                    if let startupName = json["name"] as? String,
                        let startupDesc = json["description"] as? String,
                        let startupURL = json["photoURL"] as? String,
                        let owner = json["owner"] as? String {
                        let convertedURL = URL(string: startupURL)
                        let startup = Startup(name: startupName, description: startupDesc, photoURL: convertedURL!, owner: owner)
                        startupArray.append(startup)
                    }
                }
                
            }
            completion(startupArray, nil)
        })
    }
    
    static func setStartupInDictionary(_ startup: Startup) -> [String: Any] {
        var json: [String: Any] = [:]
        
        json["name"] = startup.name
        json["description"] = startup.description
        json["photoURL"] = startup.photoURL?.absoluteString ?? ""
        json["owner"] = startup.owner
        
        return json
    }
    
    static func addStartup(_ startup: [String: Any], userID: String) {
        let rootRef = Database.database().reference()
        let mainRef = rootRef.child("main")
        let startupsRef = mainRef.child("startups")
        let startupRef = startupsRef.child(userID)
        
        startupRef.childByAutoId().setValue(startup)
    }
    
    
    
}
