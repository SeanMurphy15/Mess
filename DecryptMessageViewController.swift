//
//  DecryptMessageViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import Firebase

class DecryptMessageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var numberOfEncryptedMessages: UILabel!
    
    
    @IBOutlet weak var senderTextLabel: UILabel!
    
    
    
    var arrayOfUserMessageDictionaries = []
    var arrayOfMessageDictionaries: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfMessageDictionaries = []
        fetchMessagesForUser()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

    
    
    func fetchMessagesForUser() {
        
        
        let currentUserIdentifier = UserController.sharedController.currentUser.identifier
       
        let ref = Firebase(url:"https://messapp.firebaseio.com/messages")
        var array = [Message]()
        ref.queryOrderedByChild("messageReceiver").queryEqualToValue(currentUserIdentifier).queryLimitedToLast(100)
             .observeEventType(.ChildAdded, withBlock: { snapshot in
                if let messageDictionary = snapshot.value as? [String: String] {
                   
                    let message = Message(json: messageDictionary, identifier: snapshot.key)
                      array.append(message!)
                    
                   self.collectionView.reloadData()
                }
                self.arrayOfMessageDictionaries = array
                
                
        })
        
   
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOfMessageDictionaries!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("messageCell", forIndexPath: indexPath) as! MessageCollectionViewCell
        let message = self.arrayOfMessageDictionaries![indexPath.row]
        cell.messageLabel.text = message.encryptedMessage!
        
        numberOfEncryptedMessages.text = String(arrayOfMessageDictionaries?.count)
        
        senderTextLabel.text = message.messageSender
        
        
        return cell
    }
    
    
}

