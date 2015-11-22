//
//  FirebaseController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController{
    
    static let base = Firebase(url: "https://messapp.firebaseio.com")
    
    static let userBase = base.childByAppendingPath("Users")
    
    static func dataAtEndpoint(endpoint: String, completion: (data: AnyObject?) -> Void) {
        let firebaseForEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        firebaseForEndpoint.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value is NSNull {
                completion(data: nil)
            } else {
                completion(data: snapshot.value)
            }
        })
    }
    
    
    
    
}

protocol FirebaseType {
    
    var messageIdentifier: String? { get set }
    var endpoint: String { get }
    var jsonValue: [String: AnyObject] { get }
    
    init?(json: [String: AnyObject], messageIdentifier: String)
    
    // save and delete functions went here
}

extension FirebaseType {
    
    mutating func saveMessageToFirebase() {
        var firebaseEndpoint = FirebaseController.base.childByAppendingPath(endpoint)
        
        if let messageIdentifier = messageIdentifier {
            firebaseEndpoint = firebaseEndpoint.childByAppendingPath(messageIdentifier)
        } else {
            firebaseEndpoint = firebaseEndpoint.childByAutoId()
            messageIdentifier = firebaseEndpoint.key
        }
        
        firebaseEndpoint.updateChildValues(jsonValue)
}
    
    func deleteMessageFromFirebase() {
        if let messageIdentifier = messageIdentifier {
            let firebaseEndpoint = FirebaseController.base.childByAppendingPath(endpoint).childByAppendingPath(messageIdentifier)
            firebaseEndpoint.removeValue()
        }
    }
}


