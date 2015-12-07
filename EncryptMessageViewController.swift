//
//  EncryptMessageViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import LocalAuthentication
import MessageUI

class EncryptMessageViewController: UIViewController, MFMessageComposeViewControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var numberOfCharactersLabel: UILabel!
    
    @IBOutlet weak var messageReceiverTextLabel: UILabel!
    
    @IBOutlet weak var messageReceiverTextFieldPhoneNumber: UILabel!
    
    @IBOutlet weak var originalMessageTextView: UITextView!
    
    @IBOutlet weak var identifierLabel: UILabel!
    
    var messageRecieverTextLabelData: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageReceiverTextLabel.text = self.messageRecieverTextLabelData
        
        originalMessageTextView.delegate = self
        
        appearance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func trashButtonTapped(sender: AnyObject) {
        
        originalMessageTextView.text.removeAll()
        messageReceiverTextLabel.text?.removeAll()
    }
    
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func encryptMessageButtonTapped(sender: AnyObject) {
        
        if !originalMessageTextView.text!.isEmpty {
            
            
            promptBiometricTouchIDForEncryption()
        }
    }
    
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        numberOfCharactersLabel.text = String(originalMessageTextView.text.characters.count + 1)
        
        let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 500;
    }
    
    
    func updateMessageReceiver(user: User){
        
        messageReceiverTextLabel.text = user.email
        messageReceiverTextFieldPhoneNumber.text = user.phoneNumber
        identifierLabel.text = user.identifier
        
    }
    
    func presentModalMessageComposeViewController(animated: Bool) {
        if MFMessageComposeViewController.canSendText() {
            let messageComposeVC = MFMessageComposeViewController()
            
            
            
            messageComposeVC.messageComposeDelegate = self
            messageComposeVC.body = "You've Received an Enrypted Message: messapp://decrypt"
            messageComposeVC.recipients = [messageReceiverTextFieldPhoneNumber.text!]
            
            presentViewController(messageComposeVC, animated: animated, completion: nil)
            
        } else {
            
            let unableToSendAlert = UIAlertController(title: "Unable to Send Encrypted Message", message: " ", preferredStyle: .Alert)
            let unableToSendAlertConfirmation =  UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
                
            })
            
            unableToSendAlert.addAction(unableToSendAlertConfirmation)
            
            presentViewController(unableToSendAlert, animated: true, completion: nil)
            
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func promptBiometricTouchIDForEncryption(){
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Encryption Requires Identity Varification"
            
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] (success: Bool, authenticationError: NSError?) in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if success == true {
                        
                        if self.messageReceiverTextLabel.text == nil {
                            
                            let unableToSendAlert = UIAlertController(title: "Your Message does not have a recipient", message: " ", preferredStyle: .Alert)
                            let unableToSendAlertConfirmation =  UIAlertAction(title: "Contacts", style: .Default, handler: { (_) -> Void in
                                
                                self.performSegueWithIdentifier("toContactsFromEncryption", sender: nil)
                            })
                            
                            unableToSendAlert.addAction(unableToSendAlertConfirmation)
                            
                            self.presentViewController(unableToSendAlert, animated: true, completion: nil)
                            
                            
                        }
                        
                        self.presentModalMessageComposeViewController(true)
                        
                        let encyptedMessage = self.encryptStringWithLength(self.originalMessageTextView.text.characters.count)
                        
                        var message = Message(originalMessage: self.originalMessageTextView.text, encryptedMessage: "\(encyptedMessage)", messageReceiver: self.identifierLabel.text!, messageSender: UserController.sharedController.currentUser.email)
                        message.save()
                        
                    }else{
                        
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.promptUserPasswordAlert()
                        })
                    }
                }
            }
        }
        
    }
    
    func encryptStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghij klmnopqrstuv wxyzABCDEFG HIJKLMNOPQRS TUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    
    func promptUserPasswordAlert(){
        
        let passwordAlert = UIAlertController(title: "Enter Password", message: " ", preferredStyle: .Alert)
        passwordAlert.addTextFieldWithConfigurationHandler { (passwordField) -> Void in
            
            passwordField.placeholder = "Password"
            
        }
        
        let passwordAlertCancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let passwordAlertAction = UIAlertAction(title: "Confirm", style: .Default) { (_) -> Void in
            
            
            
            if passwordAlert.textFields?[0].text == UserController.sharedController.currentUser.password {
                
                
                if self.messageReceiverTextLabel.text == nil {
                    
                    let unableToSendAlert = UIAlertController(title: "Your Message does not have a recipient", message: " ", preferredStyle: .Alert)
                    let unableToSendAlertConfirmation =  UIAlertAction(title: "Add", style: .Default, handler: { (_) -> Void in
                        
                        self.performSegueWithIdentifier("toContactsFromEncryption", sender: nil)
                    })
                    
                    unableToSendAlert.addAction(unableToSendAlertConfirmation)
                    
                    self.presentViewController(unableToSendAlert, animated: true, completion: nil)
                    
                    
                }
                
                self.presentModalMessageComposeViewController(true)
                
                let encyptedMessage = self.encryptStringWithLength(self.originalMessageTextView.text.characters.count)
                
                var message = Message(originalMessage: self.originalMessageTextView.text, encryptedMessage: "\(encyptedMessage)", messageReceiver: self.identifierLabel.text!, messageSender: UserController.sharedController.currentUser.email)
                message.save()
            
            
            }else{
                
                passwordAlert.textFields?[0].text = ""
                
                
            }
            
        }
        
        passwordAlert.addAction(passwordAlertAction)
        
        passwordAlert.addAction(passwordAlertCancelAction)
        
        presentViewController(passwordAlert, animated: true, completion: nil)
    }
    
    
    
    //MARK: Appearance
    
    func appearance(){
        
        originalMessageTextView.layer.cornerRadius = 3.0
        
    }
    
    
    
}





