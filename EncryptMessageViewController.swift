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

class EncryptMessageViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var messageReceiverTextLabel: UILabel!
    
    @IBOutlet weak var messageReceiverTextFieldPhoneNumber: UILabel!
   
    @IBOutlet weak var originalMessageTextView: UITextView!

    
    var messageRecieverTextLabelData: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        messageReceiverTextLabel.text = self.messageRecieverTextLabelData
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MARK: Buttons
    
    
    @IBAction func trashButtonTapped(sender: AnyObject) {
        
        originalMessageTextView.text.removeAll()
        messageReceiverTextLabel.text?.removeAll()
    }
    
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            return
        }
        
    }
    
    
    
    @IBAction func encryptMessageButtonTapped(sender: AnyObject) {
        
        if !originalMessageTextView.text!.isEmpty {
            
            
           promptBiometricTouchIDForEncryption()
        }
    }
    
    func updateMessageReceiver(user: User){
        
        messageReceiverTextLabel.text = user.username
        messageReceiverTextFieldPhoneNumber.text = user.phoneNumber
        
    }
    
   func promptBiometricTouchIDForEncryption(){
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Encryption Requires Identity Varification"
            
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] (success: Bool, authenticationError: NSError?) in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if success == true {
                        
                        print("message sent")
                        
                        var message = Message(originalMessage: self.originalMessageTextView.text, encryptedMessage: "Encrypted Message", messageReceiver: "Receiver", messageSender: UserController.sharedController.currentUser.username)
                        message.save()
                        
                        
                        
                    }else{
                        
                        
                        print("not Authorized")
                    }
                }
            }
        }
        
    }
    
    
    
    func presentModalMessageComposeViewController(animated: Bool) {
        if MFMessageComposeViewController.canSendText() {
            let messageComposeVC = MFMessageComposeViewController()
            
            
           
            
            messageComposeVC.messageComposeDelegate = self
            messageComposeVC.body = "messapp://decrypt"
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

    @IBAction func smsButtonTapped(sender: AnyObject) {
        
        presentModalMessageComposeViewController(true)
        
            }
}
    
    
    

