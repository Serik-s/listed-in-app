//
//  Storage.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 16.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

import Cache

// глобальные экземпляры кэшей
struct Caches {
    static let jsonCache = try! Storage(diskConfig: DiskConfig(name: "JSON Cache"))
//    static let testJson = try? Storage(diskConfig: DiskConfig(name: "JSON Cache"))
//    static let imageCache = Storage(diskConfig: "Image Cache")
}

// константы
private struct Constants {
    static let userKey = "User"
    static let deviceKey = "Device"
    static let userSettingsKey = "UserSettings"
    static let lastTimeKey = "DateTime"
}

struct appStorage {

    static var user: User? {
        get {
            // пробуем получить пользователя в JSON формате
            // если получаем, преобразовываем в экземпляр
            // иначе возвращаем nil
            
//            if let json = try? Caches.jsonCache.object(ofType: User?.self, forKey: Constants.userKey) {
//                switch json {
//                case json: return json!
////                case .dictionary(let userJSON): return User(JSON: userJSON)!
//                default: break
//                }
//            }
//
            let json = try? Caches.jsonCache.object(ofType: User?.self, forKey: Constants.userKey)
            return json!
        
            return nil
        }
        set {
            // всякий раз когда мы изменяем авторизованного пользователя
            // если не nil, то сохраняем пользователя в JSON формате
            // иначе удаляем из памяти
            if let user = newValue {
                try! Caches.jsonCache.setObject(user, forKey: Constants.userKey)
            } else {
                try! Caches.jsonCache.removeObject(forKey: Constants.userKey)
            }
        }
    }
    
//    static var userSettings: UserSettings {
//        get {
//            if let json = Caches.jsonCache.object(forKey: Constants.userSettingsKey) {
//                switch json {
//                case .dictionary(let userSettingsJSON): return UserSettings(JSON: userSettingsJSON)!
//                default: break
//                }
//            }
//            return UserSettings.defaultSettings
//        }
//        set {
//            try! Caches.jsonCache.addObject(JSON.dictionary(newValue.toJSON()), forKey: Constants.userKey)
//        }
//    }

//    static var lastTimeSent: Int {
//        get {
//            if let json = Caches.jsonCache.object(forKey: Constants.lastTimeKey) {
//                switch json {
//                case .dictionary(let json):
//                    return (json[Constants.lastTimeKey] as! Int)
//                default: break
//                }
//            }
//            return 0
//        }
//        set {
//            let dict: [String: Any] = [Constants.lastTimeKey: newValue]
//
//            try! Caches.jsonCache.setObject(JSON.dictionary(dict), forKey: Constants.lastTimeKey)
//        }
//    }

//    static var currencyValues: [Currency: Double] = [:]
//    static var device: Device!
    static var loggedIn: Bool! = true

    static func clear() {
        user = nil
    }

}
