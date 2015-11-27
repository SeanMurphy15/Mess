//
//  EncryptMessageViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import LocalAuthentication

class EncryptMessageViewController:


    UIViewController {
    
    @IBOutlet weak var messageReceiverTextLabel: UILabel!
    
   
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
    
    func updateMessageReceivers(user: User){
        
        messageReceiverTextLabel.text = user.username
        
    }
    
   func promptBiometricTouchIDForEncryption(){
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Encryption Requires Identity Varification"
            
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] (success: Bool, authenticationError: NSError?) in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if success == true {
                        
                        print("Authorized")
                        var message = Message(originalMessage: self.originalMessageTextView.text, encryptedMessage: "Encrypted Message", messageReceiver: "Receiver", messageSender: UserController.sharedController.currentUser.username)
                        message.save()
                        
                    }else{
                        
                        
                        print("not Authorized")
                    }
                }
            }
        }
        
    }
    
    
}
