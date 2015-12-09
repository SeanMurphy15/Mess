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

@IBDesignable

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cancelButtonLabel: UIButton!
    @IBOutlet weak var messLogo: UIButton!
    
    @IBOutlet weak var inPlainSight: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
    }
    
    override func viewDidAppear(animated: Bool) {
       
         animateView()
        
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
    
    @IBAction func enterButtonTapped(sender: AnyObject) {
        
        UserController.authenticateUser(emailTextField.text!, password:passwordTextField.text!, completion: { (success, user) -> Void in
            if success == true {
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                self.deAnimateView()
                
                self.performSegueWithIdentifier("toHomeViewFromLogin", sender: nil)
                
            } else {
                
                let incompleteLoginAlert = UIAlertController(title: "User Does Not Exist", message: "Try again, or sign up!", preferredStyle: .Alert)
                let incompleteLoginAlertRedoAction = UIAlertAction(title: "Redo", style: .Default) { (_) -> Void in
                    
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
    
    
    
    //MARK: Animations
    
    //MARK: Animation
    
    func animateView(){
        
        self.emailTextField.center.x = self.view.frame.width + 300
        self.passwordTextField.center.x = self.view.frame.width - 500
        self.messLogo.center.x = self.view.frame.height + 300
        self.inPlainSight.center.x = self.view.frame.height - 500
        self.loginButton.center.x = self.view.frame.height + 300
        self.cancelButtonLabel.center.x = self.view.frame.width - 300
        
        
        
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            self.emailTextField.center.x = self.view.frame.width / 2
            self.passwordTextField.center.x = self.view.frame.width / 2
            self.messLogo.center.x = self.view.frame.height / 3.5
            self.inPlainSight.center.x = self.view.frame.height / 3.5
            self.loginButton.center.x = self.view.frame.width / 1.50
            self.cancelButtonLabel.center.x = self.view.frame.width / 2.25
            
            }, completion: nil)
        
        
    }
    
    func deAnimateView(){
        
        self.emailTextField.center.x = self.view.frame.width / 2
        self.passwordTextField.center.x = self.view.frame.width / 2
        self.messLogo.center.x = self.view.frame.height / 3.5
        self.inPlainSight.center.x = self.view.frame.height / 3.5
        self.loginButton.center.x = self.view.frame.height / 4
        self.cancelButtonLabel.center.x = self.view.frame.height / 4
        
        
        
        UIView.animateWithDuration(2.0, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            self.emailTextField.center.x = self.view.frame.width + 300
            self.passwordTextField.center.x = self.view.frame.width + 300
            self.messLogo.center.x = self.view.frame.height + 300
            self.inPlainSight.center.x = self.view.frame.height - 500
            self.loginButton.center.x = self.view.frame.height - 500
            self.cancelButtonLabel.center.x = self.view.frame.height - 500
            
            }, completion: nil)
        
    }
    
}
