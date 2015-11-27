//
//  MessageController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import Foundation
import Firebase



class messageController {
    
    
    static func messageForIdentifier(identifier: String, completion:(message: Message?) -> Void){
        
        FirebaseController.dataAtEndpoint("messages/\(identifier)") { (data) -> Void in
            
            
            if let json = data as? [String: AnyObject] {
                
                
                let message = Message(json: json, identifier: identifier)
                
                completion(message: message)
            } else {
                
                completion(message: nil)
            }
            
            
        }
        
    }
    
    
}



    
    
    
    