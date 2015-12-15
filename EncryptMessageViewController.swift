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
import AudioToolbox

@IBDesignable
class EncryptMessageViewController: UIViewController, MFMessageComposeViewControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var totalCharactersLabel: UILabel!
    @IBOutlet weak var encryptButtonLabel: UIButton!
    
    @IBOutlet weak var addReceiverLabel: UIButton!
    
    @IBOutlet weak var numberOfCharactersLabel: UILabel!
    
    @IBOutlet weak var messageReceiverTextLabel: UILabel!
    
    @IBOutlet weak var messageReceiverTextFieldPhoneNumber: UILabel!
    
    @IBOutlet weak var originalMessageTextView: UITextView!
    
    @IBOutlet weak var identifierLabel: UILabel!
    
    var messageRecieverTextLabelData: String!
    
    var initialFrame: CGRect?
    
    // var currentMessageUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageReceiverTextLabel.text = self.messageRecieverTextLabelData
        
        originalMessageTextView.delegate = self
        
        viewControllerAppearance()
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        initialFrame = self.view.frame
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func trashButtonTapped(sender: AnyObject) {
        
        originalMessageTextView.text.removeAll()
        messageReceiverTextLabel.text?.removeAll()
        numberOfCharactersLabel.text = "0"
        
    }
    
    
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func encryptMessageButtonTapped(sender: AnyObject) {
        
        
        
        
        if messageReceiverTextLabel.text?.characters.count == nil || originalMessageTextView.text!.isEmpty {
            
            let unableToSendAlert = UIAlertController(title: "Your message is not complete!", message: "Your message is blank or is missing a receiver!", preferredStyle: .Alert)
            let unableToSendAlertCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let unableToSendAlertConfirmation =  UIAlertAction(title: "Add Contact", style: .Default, handler: { (_) -> Void in
                
                self.performSegueWithIdentifier("toContactsFromEncryption", sender: nil)
            })
            
            unableToSendAlert.addAction(unableToSendAlertConfirmation)
            unableToSendAlert.addAction(unableToSendAlertCancel)
            self.presentViewController(unableToSendAlert, animated: true, completion: nil)
        }
            
        else {
            
            
            promptBiometricTouchID()
            
        }
    }
    
    //MARK: Charater limiting and counting
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        numberOfCharactersLabel.text = String(originalMessageTextView.text.characters.count + 1)
        
        let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 500;
    }
    
    
    func updateMessageReceiver(user: User){
        
        messageReceiverTextLabel.text = user.username
        messageReceiverTextFieldPhoneNumber.text = user.phoneNumber
        identifierLabel.text = user.identifier
        
    }
    
    
    //MARK: iMessage Composing View
    
    func presentModalMessageComposeViewController(animated: Bool) {
        if MFMessageComposeViewController.canSendText() {
            let messageComposeVC = MFMessageComposeViewController()
            
            let url = "m3550364797"
            
            messageComposeVC.messageComposeDelegate = self
            messageComposeVC.body = "You've received an encrypted message: messapp://\(url)"
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
    
    //MARK: Touch ID for Encryption
    
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
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = NSDateFormatterStyle.LongStyle
                    formatter.timeStyle = .LongStyle
                    
                    let timeStamp = formatter.stringFromDate(NSDate())
                    
                    self.presentModalMessageComposeViewController(true)
                    
                    let encyptedMessage = self.encryptStringWithLength(self.originalMessageTextView.text.characters.count)
                    
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    
                    var message = Message(originalMessage: self.originalMessageTextView.text, encryptedMessage: "\(encyptedMessage)", messageReceiver: self.identifierLabel.text!, messageSender: UserController.sharedController.currentUser.email, timeSent: "\(timeStamp)")
                    message.save()
                    
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
    
    //MARK: Encrypt Original Message Algorithym
    
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
    
    
    //MARK:  Touch ID Not Available
    
    
    func promptUserPasswordAlert(){
        
        let passwordAlert = UIAlertController(title: "Enter Password", message: "", preferredStyle: .Alert)
        passwordAlert.addTextFieldWithConfigurationHandler { (passwordField) -> Void in
            
            passwordField.placeholder = "Password"
            passwordField.secureTextEntry = true
            
        }
        
        let passwordAlertCancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let passwordAlertAction = UIAlertAction(title: "Confirm", style: .Default) { (_) -> Void in
            
            if passwordAlert.textFields?[0].text == UserController.sharedController.currentUser.password {
                
                
                
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.LongStyle
                formatter.timeStyle = .LongStyle
                
                let timeStamp = formatter.stringFromDate(NSDate())
                
                self.presentModalMessageComposeViewController(true)
                
                let encyptedMessage = self.encryptStringWithLength(self.originalMessageTextView.text.characters.count)
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                var message = Message(originalMessage: self.originalMessageTextView.text, encryptedMessage: "\(encyptedMessage)", messageReceiver: self.identifierLabel.text!, messageSender: UserController.sharedController.currentUser.username!, timeSent: "\(timeStamp)")
                message.save()

                
                
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
    
    
    //MARK: Appearance / animation
    
    
    func viewControllerAppearance(){
        
        originalMessageTextView.layer.cornerRadius = 5.0
        
        
        
        
        // Make Navigation controller translucent and fade in View items
        
        navigationController?.navigationBar.alpha = 0.0
        numberOfCharactersLabel.alpha = 0.0
        originalMessageTextView.alpha = 0.0
        totalCharactersLabel.alpha = 0.0
        encryptButtonLabel.alpha = 0.0
        
        addReceiverLabel.alpha = 0.0
        
        
        
        UINavigationBar.animateWithDuration(1.0) { () -> Void in
            
            self.navigationController?.navigationBar.alpha = 1.0
            self.numberOfCharactersLabel.alpha = 1.0
            self.originalMessageTextView.alpha = 1.0
            self.totalCharactersLabel.alpha = 1.0
            self.encryptButtonLabel.alpha = 1.0
            
            self.addReceiverLabel.alpha = 1.0
            
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        
        
    }
    
    
    //MARK: Keyboard Functions
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                if let NC = self.navigationController {
                
                self.view.frame = CGRectMake(0, 0, self.initialFrame!.size.width, self.initialFrame!.size.height - keyboardSize.height + NC.navigationBar.frame.size.height - 10)
                }
                }, completion: { (_) -> Void in
            })
            //            self.view.frame.origin.y -= keyboardSize.height
        }
        
        
    }
    
        
    func keyboardWillHide(notification: NSNotification) {
        
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.view.frame = self.initialFrame!
            }, completion: { (_) -> Void in
        })
    }
    
    @IBAction func unwindForSegue(unwindSegue: UIStoryboardSegue) {
        
        
    }
    
    
    
}









