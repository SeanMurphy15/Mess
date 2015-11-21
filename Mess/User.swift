//
//  User.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import Foundation
import Firebase

class User{
    
    
    var username: String
    var password: String?
    var phoneNumber: String
    
    init (username: String, phoneNumber: String){
        
        self.username = username
        self.phoneNumber = phoneNumber
        
    }
    
    init(jsonDictionary: [String : AnyObject], username: String) {
        self.username = username
        
        if let phoneNumber = jsonDictionary["phoneNumber"] as? String {
            self.phoneNumber = phoneNumber
        } else {
            self.phoneNumber = ""
        }
    }
    
    init(dictionary:[String:AnyObject]){
        
        guard let username = dictionary["username"] as? String,
            let password = dictionary["password"] as? String,
            let phoneNumber = dictionary["phoneNumber"] as? String
            else{
                
                self.username = ""
                self.password = ""
                self.phoneNumber = ""
                
                return
                
        }
        
        self.username = username
        self.password = password
        self.phoneNumber = phoneNumber
        
    }
    
    func dictionaryCopy() -> [String: AnyObject] {
        
        return [username : ["phoneNumber" : phoneNumber]]
        
    }

    
    
}
    





