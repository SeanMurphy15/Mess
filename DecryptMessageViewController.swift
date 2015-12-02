//
//  DecryptMessageViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import Firebase

class DecryptMessageViewController: UIViewController {
    private var arrayOfUserMessageDictionaries = []
    private var arrayOfMessageDictionaries = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     fetchMessagesForUser()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func fetchMessagesForUser(){
        
        let currentUserIdentifier = UserController.sharedController.currentUser.identifier
       
        let ref = Firebase(url:"https://messapp.firebaseio.com/messages")
    
        ref.queryOrderedByChild("messageReceiver").queryEqualToValue(currentUserIdentifier).queryLimitedToLast(100)
             .observeEventType(.ChildAdded, withBlock: { snapshot in
                if let messageDictionary = snapshot.value as? [String: String] {
                   
                    let message = Message(json: messageDictionary, identifier: snapshot.key)
                      self.arrayOfMessageDictionaries.append(message!)
                   
                }
            print(self.arrayOfMessageDictionaries.count)
        })
        
   
    }
    
       static func orderMessages(messages: [Message]) -> [Message] {
        
        return messages.sort({$0.0.identifier > $0.1.identifier})
    }


}
