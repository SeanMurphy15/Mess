//
//  LoginViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/27/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import LocalAuthentication
import AudioToolbox
import Firebase

@IBDesignable

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cancelButtonLabel: UIButton!
    @IBOutlet weak var messLogo: UIButton!
    
    @IBOutlet weak var inPlainSight: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var initialFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
    }
    
    override func viewDidAppear(animated: Bool) {
       
         animateView()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        initialFrame = self.view.frame
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    var user: User?
    
    func updateWithUser(user: User) {
        self.user = user
    }
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func forgotPasswordButtonTapped(sender: AnyObject) {
        
        
        let ref = Firebase(url: "https://messapp.firebaseio.com")
        ref.resetPasswordForUser(emailTextField.text!, withCompletionBlock: { error in
            if error != nil {
                
                print("there was an error signing in")
                
            } else {
                
                let emailSentAlert = UIAlertController(title: "Email Sent", message: "The email provided has received a temporary password", preferredStyle: .Alert)
                let emailSentAlertCancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                
                
                emailSentAlert.addAction(emailSentAlertCancel)
                
                self.presentViewController(emailSentAlert, animated: true, completion: nil)
            }
        })
        
        
    }
    
    @IBAction func enterButtonTapped(sender: AnyObject) {
        
        UserController.authenticateUser(emailTextField.text!, password:passwordTextField.text!, completion: { (success, user) -> Void in
            if success == true {
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
               self.deAnimateView()
                
                self.performSegueWithIdentifier("toHomeViewFromLogin", sender: nil)
                
            } else {
                
                let incompleteLoginAlert = UIAlertController(title: "User Does Not Exist", message: "Try again, or sign up!", preferredStyle: .Alert)
                let incompleteLoginAlertRedoAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                    
                    self.passwordTextField.text = ""
                    
                }
                let seguetoSignupAction = UIAlertAction(title: "Signup", style: .Default) { (_) -> Void in
                    
                    self.performSegueWithIdentifier("incompleteLoginSegue", sender: nil)
                    
                }
                
                incompleteLoginAlert.addAction(seguetoSignupAction)
                incompleteLoginAlert.addAction(incompleteLoginAlertRedoAction)
                
                self.presentViewController(incompleteLoginAlert, animated: true, completion: nil)
            }
        })
        
        
    }
    
    
    //MARK: Keyboard Functions
    
    func keyboardWillShow(notification: NSNotification) {
        
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.view.frame = CGRectMake(0, 0, self.initialFrame!.size.width, self.initialFrame!.size.height + keyboardSize.height - 400)
               
                // fade irrelevant content
                
                self.fade()
                
                }, completion: { (_) -> Void in
            })
            
        }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.view.frame = self.initialFrame!
            
            }, completion: { (_) -> Void in
        })
    }
    
    //MARK: Animation
    
    func fade(){
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.inPlainSight.alpha = 0.0
            self.messLogo.alpha = 0.0
        }
        
    }
    
    
    func animateView(){
        
        self.emailTextField.center.x = self.view.frame.width + 500
        self.passwordTextField.center.x = self.view.frame.width - 700
        self.messLogo.center.x = self.view.frame.height + 500
        self.inPlainSight.center.x = self.view.frame.height - 900
        self.loginButton.center.x = 900
        self.cancelButtonLabel.center.x = -400
        
        
        
        UIView.animateWithDuration(2.0, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            self.emailTextField.center.x = self.view.frame.width / 2
            self.passwordTextField.center.x = self.view.frame.width / 2
            self.messLogo.center.x = self.view.frame.height / 3.5
            self.inPlainSight.center.x = self.view.frame.height / 3.5
           self.loginButton.center.x = 525
          self.cancelButtonLabel.center.x = -200
            
            }, completion: nil)
        
        
    }
    
    func deAnimateView(){
        
        self.emailTextField.center.x = self.view.frame.width / 2
        self.passwordTextField.center.x = self.view.frame.width / 2
        self.messLogo.center.x = self.view.frame.height / 3.5
        self.inPlainSight.center.x = self.view.frame.height / 3.5
        self.loginButton.center.x = self.view.frame.width / 2
        self.cancelButtonLabel.center.x = self.view.frame.width / 2
        
        
        UIView.animateWithDuration(2.0, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            self.emailTextField.center.x = self.view.frame.width + 500
            self.passwordTextField.center.x = self.view.frame.width - 700
            self.messLogo.center.x = self.view.frame.height + 500
            self.inPlainSight.center.x = self.view.frame.height - 900
            self.loginButton.center.x = 900
            self.cancelButtonLabel.center.x = -400
            
            }, completion: nil)
        
    }
    
}
