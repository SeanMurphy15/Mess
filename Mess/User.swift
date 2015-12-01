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
    
    var email = ""
    var phoneNumber: String?
    var password: String?
    var identifier: String?
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
        
        return json
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        
        guard let email = json[emailKey] as? String else { return nil }
        
        self.email = email
        self.phoneNumber = json[phoneNumberKey] as? String
        self.password = json[passwordKey] as? String
        self.identifier = identifier
    }
    
    init(email: String, uid: String, phoneNumber: String?, password: String?) {
        
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
        self.identifier = uid
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    
    return (lhs.email == rhs.email) && (lhs.identifier == rhs.identifier)
}






