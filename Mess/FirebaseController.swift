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
    
}

