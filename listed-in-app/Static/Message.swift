//
//  Message.swift
//  listed-in-app
//
//  Created by Serik Seidigalimov on 16.05.2018.
//  Copyright © 2018 Serik Seidigalimov. All rights reserved.
//

enum Message {
    
    case facebookAuthError
    case wifiAuthorizationError
    case wifiFetchInfoError
    case logoutError
    case promocodeUsed
    case promocodeNotExist
    case successfullyAddedVoucher
    case usernameChanged
    case feedbackHasBeenSent
    case rebootError
    case noInternetConnection
    case connectToDevice
    case enterFeedback
    case connectPowerWiFi
    case connectedDevicesError
    case donePayment
    case notFoundTraffic
    
    case custom(String)
}

extension Message: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .facebookAuthError: return "Facebook authorization failed"
        case .wifiAuthorizationError: return "Could not connect to Router"
        case .wifiFetchInfoError: return "Could not get data from Router"
        case .promocodeUsed: return "Promocode used"
        case .promocodeNotExist: return "Promocode does not exist"
        case .successfullyAddedVoucher: return "Voucher successfully added!"
        case .logoutError: return "Could not log out"
        case .usernameChanged: return "User name has been changed"
        case .feedbackHasBeenSent: return "Your feedback has been accepted"
        case .rebootError: return "You are not connected to Wi-Fi"
        case .noInternetConnection: return "No Internet Connection"
        case .custom(let error): return error
        case .connectToDevice: return "Please, connect to your Power Wi-Fi"
        case .enterFeedback: return "Please, enter your feedback and rate network quality"
        case .connectPowerWiFi: return "Please, connect to Power WiFi"
        case .connectedDevicesError: return "Could not get connected Devices"
        case .donePayment: return "You transaction was successful"
        case .notFoundTraffic: return "Could not Found desired Traffic"
        }
    }
    
}
