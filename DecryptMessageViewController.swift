//
//  DecryptMessageViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

class DecryptMessageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var noMessagesTextLabel: UILabel!
    
    @IBOutlet weak var fromTextLabel: UILabel!
    
    @IBOutlet weak var numberOfMessagesTextLabel: UILabel!
    
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
        var arrayOfReceivedMessages = [Message]()
        ref.queryOrderedByChild("messageReceiver").queryEqualToValue(currentUserIdentifier).queryLimitedToLast(100)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                
                if let messageDictionary = snapshot.value as? [String: String] {
                    
                    let message = Message(json: messageDictionary, identifier: snapshot.key)
                    arrayOfReceivedMessages.append(message!)
                    
                    self.collectionView.reloadData()
                }
                self.arrayOfMessageDictionaries = arrayOfReceivedMessages
                
                
            })
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
               
        return self.arrayOfMessageDictionaries!.count
    
        
        }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("messageCell", forIndexPath: indexPath) as! MessageCollectionViewCell
        let message = self.arrayOfMessageDictionaries![indexPath.row]
        cell.messageLabel.text = message.encryptedMessage!
        
        
        numberOfEncryptedMessages.text? = String(arrayOfMessageDictionaries!.count)
        
        senderTextLabel.text = message.messageSender
        
        let formatter = NSDateFormatter()
        
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        cell.messageDateLabel.text = formatter.stringFromDate(NSDate())
        
        cell.messageDateLabel.hidden = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //promptBiometricTouchIDForDecryption()
        
        let indexPath = self.collectionView.indexPathsForSelectedItems()?.first
        
        let message = self.arrayOfMessageDictionaries![indexPath!.item]
        
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath!) as! MessageCollectionViewCell
        
        cell.messageLabel.text = message.originalMessage
        
        cell.messageDateLabel.hidden = false
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 0, height: collectionView.frame.width - 0)
    }
    
    
    //    func promptBiometricTouchIDForDecryption(){
    //
    //        let context = LAContext()
    //        var error: NSError?
    //
    //        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error){
    //            let reason = "Identify yourself"
    //
    //            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] (success: Bool, authenticationError: NSError?) in
    //
    //                dispatch_async(dispatch_get_main_queue()) {
    //
    //                    if success == true {
    //
    //
    //
    //
    //
    //
    //                    }else{
    //
    //
    //                        print("not Authorized, Error handle")
    //                    }
    //                }
    //            }
    //        }
    //        
    //    }
    
    
    
    
    
}

