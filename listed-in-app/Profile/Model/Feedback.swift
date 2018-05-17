//
//  Feedback.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 17.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import ObjectMapper
import Firebase

class Feedback : Mappable {
    
   
    var rating = 0
    var text = ""
    var username = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        rating <- map["rating"]
        text <- map["text"]
        username <- map["username"]
    }
    
    static func setFeedback(_ time: Date, feedback: Feedback, userID: String) {
        // Date Formatter with Time Zone
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let formattedDate = formatter.string(from: time)
        
        // main references
        let rootRef = Database.database().reference()
        let itemsRef = rootRef.child("main")
        let feedbackRef = itemsRef.child("feedbacks")
        
        // child references
        let userRef = feedbackRef.child(userID)
        let timeRef = userRef.child(formattedDate)
        
        let json = feedback.toJSON()
        timeRef.setValue(json)
    }
    
}

