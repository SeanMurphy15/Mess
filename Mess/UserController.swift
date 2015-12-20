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
    
    private let kUser = "userKey"
    
    var currentUser: User! {
        get {
            
            guard let uid = FirebaseController.base.authData?.uid else {return nil}
            
            guard let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(kUser) as? [String: AnyObject] else {
                    
                    return nil
            }
            
            return User(json: userDictionary, identifier: uid)
        }
        
        set {
            
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    
    static let sharedController = UserController()
    
    static func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        
        FirebaseController.dataAtEndpoint("users/\(identifier)") { (data) -> Void in
            
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, identifier: identifier)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        
        FirebaseController.dataAtEndpoint("users") { (data) -> Void in
            
            if let json = data as? [String: AnyObject] {
                
                let users = json.flatMap({User(json: $0.1 as! [String : AnyObject], identifier: $0.0)})
                
                completion(users: users)
                
            } else {
                completion(users: [])
            }
        }
    }
    
    static func updateUser(user: User, email: String, phoneNumber: String?, password: String?, username: String, deviceID: String?, completion: (success: Bool, user: User?) -> Void) {
        var updatedUser = User(email: user.email, uid: user.identifier!, phoneNumber : phoneNumber, password: password, username: username, deviceID: deviceID)
        updatedUser.save()
        
        UserController.userForIdentifier(user.identifier!) { (user) -> Void in
            
            if let user = user {
                sharedController.currentUser = user
                completion(success: true, user: user)
            } else {
                completion(success: false, user: nil)
            }
        }
    }
    
    
    
    static func authenticateUser(email: String, password: String, completion: (success: Bool, user: User?) -> Void) {
        
        FirebaseController.base.authUser(email, password: password) { (error, response) -> Void in
            
            if error != nil {
                print("Unsuccessful login attempt.")
                completion(success: false, user: nil)
            } else {
                print("User ID: \(response.uid) authenticated successfully.")
                UserController.userForIdentifier(response.uid, completion: { (user) -> Void in
                    
                    if let user = user {
                        sharedController.currentUser = user
                    }
                    
                    completion(success: true, user: user)
                })
            }
        }
    }
    
    static func createUser(email: String, password: String, phoneNumber: String?,username: String?,deviceID:String?, completion: (success: Bool, user: User?, error: NSError?) -> Void) {
        
        FirebaseController.base.createUser(email, password: password) { (error, response) -> Void in
            
            
            if !(error == nil) {
                print(error.localizedDescription)
                completion(success: false, user: nil, error: error)
            } else {
                if let uid = response["uid"] as? String {
                    var user = User(email: email, uid: uid, phoneNumber: phoneNumber, password: password,username: username, deviceID: deviceID)
                    user.save()
                    
                    authenticateUser(email, password: password, completion: { (success, user) -> Void in
                        completion(success: success, user: user, error: nil)
                    })
                } else {
                    completion(success: false, user: nil, error: nil)
                }
            }
        }
    }
    
   static func logoutCurrentUser() {
        FirebaseController.base.unauth()
        UserController.sharedController.currentUser = nil
    }
    
}
