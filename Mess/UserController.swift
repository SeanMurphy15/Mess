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
    
    
    static let sharedController = UserController()
    
    
    
    var users: [User]
    
    init(){
        
        self.users = []
        loadUsers()
    }
    
    
    func loadUsers(){
        
        let allUsersReference = FirebaseController.userBase
        
        allUsersReference.observeSingleEventOfType(FEventType.Value, withBlock: { (snapshot) -> Void in
            
            
            if let userDictionaries = snapshot.value as? [[String:AnyObject]]{
                
                self.users = userDictionaries.map({User(dictionary: $0)})
                
            }
            
            
        })
        
    }
    
    func addUser(user: User){
        
        users.append(user)
        
    }
    
    
    func saveUserToFirebase(){
        
        
        let userDictionaries = self.users.map({$0.dictionaryCopy()})
        
        FirebaseController.userBase.setValue(userDictionaries)
        
    }
    
}
    
    
    
    



