//
//  Message.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import Foundation


class Message {
    
    var originalMessage: String
    var messageReceiver: String
    var messageSender: String
    
    
    
    init (originalMessage: String, messageReceiver: String, messageSender: String){
    
        self.originalMessage = originalMessage
        self.messageReceiver = messageReceiver
        self.messageSender = messageSender
        
    }
    
}