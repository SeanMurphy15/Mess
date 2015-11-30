//
//  Message.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import Foundation


class Message: FirebaseType {
    
    private let originalMessageKey = "originalMessage"
    private let messageReceiverKey = "messageReceiver"
    private let messageSenderKey = "messageSender"
    private let encryptedMessageKey = "encryptedMessage"
    
    
    var originalMessage: String = ""
    var messageReceiver: String?
    var messageSender: String?
    var encryptedMessage: String?
    var identifier: String?
    var endpoint: String {
        
        return "messages"
    }
    
    var jsonValue: [String: AnyObject] {
        
        var json: [String: AnyObject] = [originalMessageKey: originalMessage]
        
        if let messageReceiver = messageReceiver {
            
            json.updateValue(messageReceiver, forKey: messageReceiverKey)
        }
        if let messageSender = messageSender {
            
            json.updateValue(messageSender, forKey: messageSenderKey)
        }
        
        if let encryptedMessage = encryptedMessage {
            
            json.updateValue(encryptedMessage, forKey: encryptedMessageKey)
        }
        
        return json
        
    }
    
    required init?(json: [String: AnyObject], identifier: String){
        
        guard let originalMessage = json[originalMessageKey] as? String else {return nil}
        self.originalMessage = originalMessage
        self.messageReceiver = json[messageReceiverKey] as? String
        self.messageSender = json[messageSenderKey] as? String
        self.encryptedMessage = json[encryptedMessageKey] as? String
        self.identifier = identifier
    }
    
    
    
    init (originalMessage: String, encryptedMessage: String, messageReceiver: String, messageSender: String){
        
        self.originalMessage = originalMessage
        self.messageReceiver = messageReceiver
        self.messageSender = messageSender
        self.encryptedMessage = encryptedMessage
    }
    
    
}
