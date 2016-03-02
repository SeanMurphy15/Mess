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
    
    
   
   
   
    
    @IBOutlet weak var deleteButton: UIButton!
    
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
        navigationBarAppearance()

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    //MARK: Get messages for user
    
    
    func fetchMessagesForUser() {
        
        //UserController.sharedController.currentUser.identifier

        let currentUserIdentifier = UserController.sharedController.currentUser.identifier
        let ref = Firebase(url:"https://messapp.firebaseio.com/messages")
        var arrayOfReceivedMessages = [Message]()
        ref.queryOrderedByChild("messageReceiver").queryEqualToValue(currentUserIdentifier).queryLimitedToLast(100)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                
                if let messageDictionary = snapshot.value as? [String: String] {
                    
                    let message = Message(json: messageDictionary, identifier: snapshot.key)
                    
                    
                    arrayOfReceivedMessages.append(message!)

                    arrayOfReceivedMessages.sortInPlace({ (message1, message2) -> Bool in
                        
                        message1.identifier > message2.identifier
                    })
                    
                    self.collectionView.reloadData()
                }
                self.arrayOfMessageDictionaries = arrayOfReceivedMessages
                
                
            })
        }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return self.arrayOfMessageDictionaries!.count
        
        
    }
    
    //MARK: Configure Cell in CollectionView
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("messageCell", forIndexPath: indexPath) as! MessageCollectionViewCell
        let message = self.arrayOfMessageDictionaries![indexPath.row]
        
        cell.messageTextView.text = message.encryptedMessage!
        
        self.collectionView.layer.borderColor = UIColor.whiteColor().CGColor
        
        numberOfEncryptedMessages.text? = String(arrayOfMessageDictionaries!.count)
        
        senderTextLabel.text = message.messageSender
        
        cell.messageDateLabel.text = message.timeSent
        
        cell.messageDateLabel.alpha = 0.0
        
        cell.decryptButtonOverlayLabel.alpha = 1.0
        
        
        return cell
    }
    
     // MARK: Redundant function. Consider deleting

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        promptBiometricTouchID()
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        
        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height )
    }
    
    
    
    func showOriginalMessage(){
        
        
        let indexPath = self.collectionView.indexPathsForVisibleItems().first
        
        let message = self.arrayOfMessageDictionaries![indexPath!.item]
        
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath!) as! MessageCollectionViewCell
        
        //let progressTime = Double(cell.messageTextView.text.characters.count)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            cell.messageTextView.text = message.originalMessage
            
            cell.messageDateLabel.alpha = 0.0
            
            cell.messageTextView.alpha = 0.0
            
            self.collectionView.layer.borderColor = UIColor.greenColor().CGColor
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                
                cell.messageDateLabel.alpha = 1.0
                cell.messageTextView.alpha = 1.0
                cell.decryptButtonOverlayLabel.alpha = 0.0
                

            })
        })
        
    }
    
    @IBAction func decryptOverlayButtonPressed(sender: AnyObject) {
        
        promptBiometricTouchID()
        
        
    }
    
    
    
    //MARK: Touch ID is not available
    
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
    
    
    //MARK: Called when user fails touchID
    
    func promptUserPasswordAlert(){
        
        let passwordAlert = UIAlertController(title: "Enter Password", message: "Touch ID is not available on your device.", preferredStyle: .Alert)
        passwordAlert.addTextFieldWithConfigurationHandler { (passwordField) -> Void in
            
            passwordField.placeholder = "Password"
            passwordField.secureTextEntry = true
            
        }
        
        let passwordAlertCancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let passwordAlertAction = UIAlertAction(title: "Confirm", style: .Default) { (_) -> Void in
            
            if passwordAlert.textFields?[0].text == UserController.sharedController.currentUser.password {
                
                
                self.showOriginalMessage()
                
                
                
            }else{
                
                passwordAlert.textFields?[0].text = ""
                
                
                
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
                    let indexPath = self.collectionView.indexPathsForVisibleItems().first
                    
                    _ = self.arrayOfMessageDictionaries![indexPath!.item]
                    
                    _ = self.collectionView.cellForItemAtIndexPath(indexPath!) as! MessageCollectionViewCell
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.showOriginalMessage()
                        
                    })
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        switch (authenticationError!.code) {
                        case LAError.AuthenticationFailed.rawValue:
                            self.promptUserPasswordAlert()
                            break;
                        case LAError.UserFallback.rawValue:
                            self.promptUserPasswordAlert()
                            break;
                        case LAError.UserCancel.rawValue:
                            break;
                            
                        default:
                            break;
                        }
                        
                        
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
    
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        
        
        let indexPath = self.collectionView.indexPathsForVisibleItems().first
        
        if self.arrayOfMessageDictionaries?.count > 0 {
        
        let message = self.arrayOfMessageDictionaries![indexPath!.item]
            
            
            _ = self.collectionView.cellForItemAtIndexPath(indexPath!) as! MessageCollectionViewCell
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
                self.collectionView.center.x = self.view.frame.width - 600
                
                }, completion: { (_) -> Void in
                    
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.collectionView.center.x = self.view.frame.width + 600
                        self.collectionView.alpha = 1.0
                        self.collectionView.layer.borderColor = UIColor.whiteColor().CGColor
                    })
                    
                   if let indexPath = indexPath {
                        message.delete()
                        self.arrayOfMessageDictionaries?.removeAtIndex(indexPath.item)
                        self.collectionView.reloadData()
                        
                    }
            })
                
           
        } else {
        
            let noMoreMessagesAlert = UIAlertController(title: "No Messages!", message: "Your inbox is empty", preferredStyle: .Alert)
            let noMoreMessagesAlertCancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            
            noMoreMessagesAlert.addAction(noMoreMessagesAlertCancel)
            presentViewController(noMoreMessagesAlert, animated: true, completion: nil)
        }
        
        
        

    }
    
    
    func animateView(){
        

        collectionView.layer.borderWidth = 5.0
        collectionView.layer.cornerRadius = 10.0
        collectionView.layer.borderColor = UIColor.whiteColor().CGColor
        
        

        
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
    
    
    func navigationBarAppearance(){
        
                // Make Navigation controller translucent
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
    }


    
}

