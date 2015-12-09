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
import QuartzCore

class LoginSignupViewController: UIViewController{
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var messLogo: UIButton!
    
    @IBOutlet weak var inPlainSight: UIButton!
    @IBOutlet weak var signupButtonLabel: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        // Do any additional setup after loading the view.
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
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        
        
        //MARK: - Error handle unequal passwords
        //MARK: - Create new user
        
        
        if !emailTextField.text!.isEmpty && !phoneNumberTextField.text!.isEmpty && passwordTextField.text == reEnterPasswordTextField.text && !passwordTextField.text!.isEmpty && !reEnterPasswordTextField.text!.isEmpty {
            
            
            UserController.createUser(emailTextField.text!, password: passwordTextField.text!, phoneNumber: phoneNumberTextField.text!, completion: { (success, user) -> Void in
                
                self.performSegueWithIdentifier("toHomeViewFromSignup", sender: nil)
               
                self.deAnimateView()
            })
            
        }
        else{
            
            let incompleteSignupAlert = UIAlertController(title: "Incomplete Submission", message: "You have not filled in all the boxes", preferredStyle: .Alert)
            let incompleteSignupAlertRedoAction = UIAlertAction(title: "Redo", style: .Default) { (_) -> Void in
                
            }
            
            incompleteSignupAlert.addAction(incompleteSignupAlertRedoAction)
            
            presentViewController(incompleteSignupAlert, animated: true, completion: nil)
            
        }
        
        if passwordTextField.text! != reEnterPasswordTextField.text! {
            
            let passwordAlert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .ActionSheet)
            let redoPasswordAction = UIAlertAction(title: "Redo", style: .Default) { (_) -> Void in
                
                self.resetPasswordTextFields()
                
            }
            
            passwordAlert.addAction(redoPasswordAction)
            
            presentViewController(passwordAlert, animated: true, completion: nil)
            
            
        }
        
        
    }
        
    //MARK: Animation
    
    func animateView(){
    
        self.emailTextField.center.x = self.view.frame.width + 300
        self.passwordTextField.center.x = self.view.frame.width + 300
        self.reEnterPasswordTextField.center.x = self.view.frame.width - 500
        self.phoneNumberTextField.center.x = self.view.frame.width - 500
        self.messLogo.center.x = self.view.frame.height + 300
        self.inPlainSight.center.x = self.view.frame.height - 500
        self.signupButtonLabel.center.x = self.view.frame.height + 500
        self.cancelButton.center.x = self.view.frame.height - 500


        
        UIView.animateWithDuration(2.0, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            self.emailTextField.center.x = self.view.frame.width / 2
            self.passwordTextField.center.x = self.view.frame.width / 2
            self.reEnterPasswordTextField.center.x = self.view.frame.width / 2
            self.phoneNumberTextField.center.x = self.view.frame.width / 2
            self.messLogo.center.x = self.view.frame.height / 2
            self.inPlainSight.center.x = self.view.frame.height / 2
            self.signupButtonLabel.center.x = self.view.frame.height / 2
            self.cancelButton.center.x = self.view.frame.height / 2
            
            }, completion: nil)
    
    
    }
    
    func deAnimateView(){
        
        self.emailTextField.center.x = self.view.frame.width / 2
        self.passwordTextField.center.x = self.view.frame.width / 2
        self.reEnterPasswordTextField.center.x = self.view.frame.width / 2
        self.phoneNumberTextField.center.x = self.view.frame.width / 2
        self.messLogo.center.x = self.view.frame.height / 2
        self.inPlainSight.center.x = self.view.frame.height / 2
        self.signupButtonLabel.center.x = self.view.frame.height / 2
        self.cancelButton.center.x = self.view.frame.height / 2
        
        
        
        UIView.animateWithDuration(2.0, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            self.emailTextField.center.x = self.view.frame.width + 300
            self.passwordTextField.center.x = self.view.frame.width + 300
            self.reEnterPasswordTextField.center.x = self.view.frame.width - 500
            self.phoneNumberTextField.center.x = self.view.frame.width - 500
            self.messLogo.center.x = self.view.frame.height + 300
            self.inPlainSight.center.x = self.view.frame.height - 500
            self.signupButtonLabel.center.x = self.view.frame.height + 500
            self.cancelButton.center.x = self.view.frame.height - 500
            
            }, completion: nil)
    
    }

}