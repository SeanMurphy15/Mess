//
//  User.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import Foundation
import Firebase

struct User: Equatable, FirebaseType {
    
    private let emailKey = "email"
    private let phoneNumberKey = "phoneNumber"
    private let passwordKey = "password"
    private let usernameKey = "username"
    private let deviceIDKey = "deviceID"
    
    var email = ""
    var username: String?
    var phoneNumber: String?
    var password: String?
    var identifier: String?
    var deviceID: String?
    var endpoint: String {
        return "users"
    }
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [emailKey: email]
        
        if let phoneNumber = phoneNumber {
            json.updateValue(phoneNumber, forKey: phoneNumberKey)
        }
        
        if let password = password {
            json.updateValue(password, forKey: passwordKey)
        }
        
        
        if let username = username {
            json.updateValue(username, forKey: usernameKey)
        }
        if let deviceID = deviceID {
            json.updateValue(deviceID, forKey: deviceIDKey)
        }
        
        return json
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        
        guard let email = json[emailKey] as? String else { return nil }
        
        self.email = email
        self.phoneNumber = json[phoneNumberKey] as? String
        self.password = json[passwordKey] as? String
        self.username = json[usernameKey] as? String
        self.deviceID = json[deviceIDKey] as? String
        self.identifier = identifier
    }
    
    init(deviceID: String){
        
        self.deviceID = deviceID
    }
    
    init(email: String, uid: String, phoneNumber: String?, password: String?, username: String?, deviceID: String?) {
        
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
        self.username = username
        self.deviceID = deviceID
        self.identifier = uid
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    
    return (lhs.email == rhs.email) && (lhs.identifier == rhs.identifier)
}






