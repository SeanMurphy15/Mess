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
import AudioToolbox

@IBDesignable

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
        animateView()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createEncryptedMessageTapped(sender: AnyObject) {
        
        self.performSegueWithIdentifier("toEncryptFromDecrypt", sender: nil)
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
        cell.messageTextView.text = message.encryptedMessage!
        
        
        numberOfEncryptedMessages.text? = String(arrayOfMessageDictionaries!.count)
        
        senderTextLabel.text = message.messageSender
        
        collectionViewAppearance()
        
        cell.messageDateLabel.text = message.timeSent
        
        cell.messageDateLabel.alpha = 0.0
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        promptBiometricTouchID()
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        
        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height )
    }
    
    
    func touchIDNotAvailableAlert() {
        let touchIDAlert = UIAlertController(title: "Touch ID Not Available", message: "", preferredStyle: .Alert)
        let touchIDAlertCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let touchIDAlertAction = UIAlertAction(title: "Enter Password", style: .Default) { (_) -> Void in
            self.promptUserPasswordAlert()
        }
        
        touchIDAlert.addAction(touchIDAlertAction)
        touchIDAlert.addAction(touchIDAlertCancel)
        presentViewController(touchIDAlert, animated: true, completion: nil)
        
    }
    
    func promptUserPasswordAlert(){
        
        let passwordAlert = UIAlertController(title: "Enter Password", message: "Touch ID is not available on your device.", preferredStyle: .Alert)
        passwordAlert.addTextFieldWithConfigurationHandler { (passwordField) -> Void in
            
            passwordField.placeholder = "Password"
            passwordField.secureTextEntry = true
            
        }
        
        let passwordAlertCancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let passwordAlertAction = UIAlertAction(title: "Confirm", style: .Default) { (_) -> Void in
            
            if passwordAlert.textFields?[0].text == UserController.sharedController.currentUser.password {
                
                
                
                let indexPath = self.collectionView.indexPathsForSelectedItems()?.first
                
                let message = self.arrayOfMessageDictionaries![indexPath!.item]
                
                let cell = self.collectionView.cellForItemAtIndexPath(indexPath!) as! MessageCollectionViewCell
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    cell.messageTextView.text = message.originalMessage
                    
                    UIView.animateWithDuration(1.0, animations: { () -> Void in
                        
                        cell.messageDateLabel.alpha = 1.0
                    })
                    
                    
                })
                
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                print("User Fallback Validated")
                
                
                
            }else{
                
                passwordAlert.textFields?[0].text = " "
                
                
            }
            
        }
        
        passwordAlert.addAction(passwordAlertAction)
        
        passwordAlert.addAction(passwordAlertCancelAction)
        
        presentViewController(passwordAlert, animated: true, completion: nil)
    }
    
    
    func promptBiometricTouchID(){
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:&error) {
            
            // evaluate
            
            let reason = "Authenticate"
            
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: {
                (success: Bool, authenticationError: NSError?) -> Void in
                
                // check whether evaluation of fingerprint was successful
                if success {
                    let indexPath = self.collectionView.indexPathsForSelectedItems()?.first
                    
                    let message = self.arrayOfMessageDictionaries![indexPath!.item]
                    
                    let cell = self.collectionView.cellForItemAtIndexPath(indexPath!) as! MessageCollectionViewCell
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        cell.messageTextView.text = message.originalMessage
                        
                        UIView.animateWithDuration(1.0, animations: { () -> Void in
                            
                            cell.messageDateLabel.alpha = 1.0
                        })
                        
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    })
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.promptUserPasswordAlert()
                        
                    })
                }
            })
            
        } else {
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.touchIDNotAvailableAlert()
                
            })
            
            
            
        }
    }
    
    
    //MARK: Appearance
    
    
    func animateView(){
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        
        navigationController?.navigationBar.alpha = 0.0
        fromTextLabel.alpha = 0.0
        numberOfMessagesTextLabel.alpha = 0.0
        collectionView.alpha = 0.0
        numberOfEncryptedMessages.alpha = 0.0
        senderTextLabel.alpha = 0.0
        senderTextLabel.alpha = 0.0
        
        
        
        UINavigationBar.animateWithDuration(1.0) { () -> Void in
            
            self.navigationController?.navigationBar.alpha = 1.0
            self.fromTextLabel.alpha = 1.0
            self.numberOfMessagesTextLabel.alpha = 1.0
            self.collectionView.alpha = 1.0
            self.numberOfEncryptedMessages.alpha = 1.0
            self.senderTextLabel.alpha = 1.0
            self.senderTextLabel.alpha = 1.0
            
        }
        
    }
    
    
    func collectionViewAppearance(){
        
        collectionView.layer.borderWidth = 5.0
        collectionView.layer.cornerRadius = 5.0
        collectionView.layer.borderColor = UIColor.whiteColor().CGColor
        collectionView.layer.shadowColor = UIColor.blackColor().CGColor
        
        // Make Navigation controller translucent
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
    }
    
    
}

