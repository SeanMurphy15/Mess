//
//  SettingsViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    var user = UserController.sharedController.currentUser

    @IBOutlet weak var newPasswordTextField: UITextField!
   
    @IBOutlet weak var reEnterNewPasswordTextField: UITextField!
    
    @IBOutlet weak var newPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var reEnterNewPhoneNumberTextField: UITextField!
    @IBOutlet weak var currentUserTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setCurrentUser()
        
    }
    
    func setCurrentUser(){
        
        currentUserTextLabel.text = UserController.sharedController.currentUser.email
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        }
    
    
    func passwordError(){
        
        let unableToChangePasswordAlert = UIAlertController(title: "Unable To Change Password", message: " ", preferredStyle: .Alert)
        let unableToChangePasswordAlertAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in
            
            self.newPasswordTextField.text? = ""
            self.reEnterNewPasswordTextField.text? = ""
        }
        
        unableToChangePasswordAlert.addAction(unableToChangePasswordAlertAction)
        self.presentViewController(unableToChangePasswordAlert, animated: true, completion: nil)
        
    }

    
    
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
       
        
        if !newPasswordTextField.text!.isEmpty && !reEnterNewPasswordTextField.text!.isEmpty && newPasswordTextField.text == reEnterNewPasswordTextField.text {
            
            let settingsAlert = UIAlertController(title: "Do you wish to change your Password?", message: " ", preferredStyle: .Alert)
            let cancelPasswordChange = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) -> Void in
            })
                let settingsAlertAction = UIAlertAction(title: "Confirm", style: .Default, handler: { (_) -> Void in
                    
                    let ref = Firebase(url: "https://messapp.firebaseio.com")
                    ref.changePasswordForUser(UserController.sharedController.currentUser.email, fromOld: UserController.sharedController.currentUser.password,
                        toNew: self.newPasswordTextField.text, withCompletionBlock: { error in
                            if error != nil {
                                
                                self.passwordError()
                                
                            } else {
                                
                                self.user.save()
                                
                                self.performSegueWithIdentifier("savedFromSettings", sender: nil)
                            }
                    })
                    
                })
                
            
                settingsAlert.addAction(settingsAlertAction)
                settingsAlert.addAction(cancelPasswordChange)
                
               self.presentViewController(settingsAlert, animated: true, completion: nil)
                
                
            
            
        }
        
        if !newPhoneNumberTextField.text!.isEmpty && !reEnterNewPhoneNumberTextField.text!.isEmpty && newPhoneNumberTextField.text == reEnterNewPhoneNumberTextField.text {
            
            
            let settingsAlert = UIAlertController(title: "Do you wish to change your Phone Number?", message: " ", preferredStyle: .Alert)
                let settingsAlertAction = UIAlertAction(title: "Confirm", style: .Default, handler: { (_) -> Void in
                   
                 self.user.phoneNumber = self.newPhoneNumberTextField.text
                    
                    self.user.save()
                    
                    
                        self.performSegueWithIdentifier("savedFromSettings", sender: nil)
                        
                    })
                
                settingsAlert.addAction(settingsAlertAction)
                
                self.presentViewController(settingsAlert, animated: true, completion: nil)
                
                
            
            
        }
        
        
    }
    
    
    
    @IBAction func deleteAccountButtonTapped(sender: AnyObject) {
        
        user.delete()
        self.performSegueWithIdentifier("toInitialViewController", sender: nil)
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        UserController.logoutCurrentUser()
        self.performSegueWithIdentifier("toInitialViewController", sender: nil)
    }
    
    
    
    
    
 
   }
