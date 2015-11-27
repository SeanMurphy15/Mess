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
    
    private let usernameKey = "username"
    private let phoneNumberKey = "phoneNumber"
    private let passwordKey = "password"
    
    var username = ""
    var phoneNumber: String?
    var password: String?
    var identifier: String?
    var endpoint: String {
        return "Users"
    }
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [usernameKey: username]
        
        if let phoneNumber = phoneNumber {
            json.updateValue(phoneNumber, forKey: phoneNumberKey)
        }
        
        if let password = password {
            json.updateValue(password, forKey: passwordKey)
        }
        
        return json
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        
        guard let username = json[usernameKey] as? String else { return nil }
        
        self.username = username
        self.phoneNumber = json[phoneNumberKey] as? String
        self.password = json[passwordKey] as? String
        self.identifier = identifier
    }
    
    init(username: String, uid: String, phoneNumber: String?, password: String?) {
        
        self.username = username
        self.phoneNumber = phoneNumber
        self.password = password
        self.identifier = uid
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    
    return (lhs.username == rhs.username) && (lhs.identifier == rhs.identifier)
}






