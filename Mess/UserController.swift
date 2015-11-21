//
//  UserController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import Foundation
import Firebase


class UserController {
    
    

    
    var users: [User] = []
    
    static func loadUsers(completion: (users: [User]) -> Void) {
        
        let allUsersReference = FirebaseController.userBase
        
        allUsersReference.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) -> Void in
            
        if let userDictionaries = snapshot.value as? [String:[String: AnyObject]] {
                
                let keys = Array(userDictionaries.keys)
                var users = [User]()
                
                for key in keys {
                    users.append(User(jsonDictionary: userDictionaries[key]!, username: key))
                }
                
                completion(users: users)
            }
        })
        
    }
        
    
    static func saveUserToFirebase(user: User) {
        
        
        FirebaseController.userBase.updateChildValues(user.dictionaryCopy())
        
    }
    
    
    
}
    
    
    
    



