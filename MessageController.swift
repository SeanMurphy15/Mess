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

//    static func messageNotifications(messageSender: String, messageCount: Int){
//
//        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
//
//        if settings!.types == .None {
//            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//
//            return
//
//        }
//
//        let notification = UILocalNotification()
//        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
//        notification.alertBody = "\(messageSender) has sent you an encrypted message"
//        notification.alertAction = "Confirm"
//        notification.applicationIconBadgeNumber = messageCount
//        notification.soundName = UILocalNotificationDefaultSoundName
//        notification.userInfo = ["CustomField1": "w00t"]
//        UIApplication.sharedApplication().scheduleLocalNotification(notification)
//        
//        
//    }

    
    
}



    
    
    
    