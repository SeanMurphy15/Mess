//
//  LoginSignupViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication
import DigitsKit


class LoginSignupViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var messLogo: UIButton!
    
    @IBOutlet weak var inPlainSight: UIButton!
    @IBOutlet weak var signupButtonLabel: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    
    
    var initialFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Digits.sharedInstance().logOut()
        
        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        initialFrame = self.view.frame
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func resetPasswordTextFields(){
        
        passwordTextField.text?.removeAll()
        reEnterPasswordTextField.text?.removeAll()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        animateView()
    }
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == phoneNumberTextField {
            resignFirstResponder()
            verifyPhone()
            
        }
    }
    
    func verifyPhone(){
        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        configuration.appearance = DGTAppearance()
        
        configuration.appearance.logoImage = UIImage(named: "messLogo-digits-logo")
        
        configuration.appearance.labelFont = UIFont(name: "HelveticaNeue-Bold", size: 16)
        configuration.appearance.bodyFont = UIFont(name: "HelveticaNeue-Italic", size: 16)
        
        configuration.appearance.accentColor = UIColor.whiteColor()
        configuration.appearance.backgroundColor = UIColor(red: 4/255, green: 197/255, blue: 255/255, alpha: 1.0)
        
        Digits.sharedInstance().authenticateWithViewController(self, configuration: configuration) { (session, error) -> Void in
            if (session != nil) {
                
               
                    self.phoneNumberTextField.text = session.phoneNumber
                    self.phoneNumberTextField.layer.borderColor = UIColor.greenColor().CGColor
                    self.phoneNumberTextField.layer.borderWidth = 5.0
                    self.phoneNumberTextField.layer.cornerRadius = 5.0
                                    
               
                self.phoneNumberTextField.text = session.phoneNumber
                self.phoneNumberTextField.layer.borderColor = UIColor.greenColor().CGColor
                self.phoneNumberTextField.layer.borderWidth = 5.0
                self.phoneNumberTextField.layer.cornerRadius = 5.0
                
                let message = "Phone number: \(session!.phoneNumber)"
                let alertController = UIAlertController(title: "Your phone has been verified!", message: message, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: .None))
                self.presentViewController(alertController, animated: true, completion: .None)
            }
            else {
                
                let alertController = UIAlertController(title: "Error", message:"\(error.localizedDescription)" , preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: .None))
                self.presentViewController(alertController, animated: true, completion: .None)
            }
            
        }
        
    }
    
    //MARK: Signup Button tapped
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        
        
        //MARK: - Error handle unequal passwords
        //MARK: - Create new user
        
        
        if !emailTextField.text!.isEmpty && !phoneNumberTextField.text!.isEmpty && !usernameTextField.text!.isEmpty  && passwordTextField.text == reEnterPasswordTextField.text && !passwordTextField.text!.isEmpty && !reEnterPasswordTextField.text!.isEmpty {
            
            
            UserController.createUser(emailTextField.text!, password: passwordTextField.text!, phoneNumber: phoneNumberTextField.text!, username: usernameTextField.text!, completion: { (success, var user, error) -> Void in
                
                if success {
                    user?.save()
                    
                    self.performSegueWithIdentifier("toHomeViewFromSignup", sender: nil)
                    
                } else {
                    if let error = error {
                       
                    let incompleteSignupAlert = UIAlertController(title: "Incomplete Submission", message: "\(error.localizedDescription)", preferredStyle: .Alert)
                    let incompleteSignupAlertRedoAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                        
                    }
                    
                    incompleteSignupAlert.addAction(incompleteSignupAlertRedoAction)
                    
                    self.presentViewController(incompleteSignupAlert, animated: true, completion: nil)
                }
                
                }
            })
            
        }
        
        if passwordTextField.text! != reEnterPasswordTextField.text! {
            
            let passwordAlert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .Alert)
            let redoPasswordAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
                
                self.resetPasswordTextFields()
                
            }
            
            passwordAlert.addAction(redoPasswordAction)
            
            presentViewController(passwordAlert, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    //MARK: Keyboard Function
    
    func keyboardWillShow(notification: NSNotification) {
        
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.view.frame = CGRectMake(0, 0, self.initialFrame!.size.width, self.initialFrame!.size.height - keyboardSize.height + 20)
                
                self.inPlainSight.hidden = true
                self.messLogo.hidden = true
                
                }, completion: { (_) -> Void in
            })
            
        }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.view.frame = self.initialFrame!
            }, completion: { (_) -> Void in
                
                self.inPlainSight.hidden = false
                self.messLogo.hidden = false
        })
    }
    
    @IBAction func unwindForSegue(unwindSegue: UIStoryboardSegue) {
        
        
    }
    
    //MARK: Animations
    
    func animateView(){
        
        self.emailTextField.center.x = self.view.frame.width + 400
        self.usernameTextField.center.x = self.view.frame.width - 700
        self.passwordTextField.center.x = self.view.frame.width + 400
        self.reEnterPasswordTextField.center.x = self.view.frame.width - 700
        self.phoneNumberTextField.center.x = self.view.frame.width - 700
        
        self.messLogo.center.x = self.view.frame.height + 500
        self.inPlainSight.center.x = self.view.frame.height - 700
        self.signupButtonLabel.center.x = self.view.frame.height + 300
        self.cancelButton.center.x = self.view.frame.height - 700
        
        
        
        UIView.animateWithDuration(1.0, delay: 0.75, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
            
            self.emailTextField.center.x = self.view.frame.width / 2
            self.usernameTextField.center.x = self.view.frame.width / 2
            self.passwordTextField.center.x = self.view.frame.width / 2
            self.reEnterPasswordTextField.center.x = self.view.frame.width / 3
            self.phoneNumberTextField.center.x = self.view.frame.width / 3
            
            self.messLogo.center.x = self.view.frame.height / 2
            self.inPlainSight.center.x = self.view.frame.height / 2
            self.signupButtonLabel.center.x = self.view.frame.height / 2
            self.cancelButton.center.x = self.view.frame.height / 2
            
            }, completion: nil)
        
        
    }
    
    
    
}

