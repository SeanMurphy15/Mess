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
        
        var currentUserIdentifier = UserController.sharedController.currentUser.identifier
        
        let ref = Firebase(url:"https://messapp.firebaseio.com/messages")
        ref.queryOrderedByChild(currentUserIdentifier).queryLimitedToLast(100)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                print(snapshot.key)
            })
        
    }
    

}
