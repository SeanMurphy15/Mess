//
//  SettingsViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit

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
        
        currentUserTextLabel.text = UserController.sharedController.currentUser.username
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        }
    
    
    
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
       
        
        if !newPasswordTextField.text!.isEmpty && !reEnterNewPasswordTextField.text!.isEmpty && newPasswordTextField.text == reEnterNewPasswordTextField.text {
            
            let settingsAlert = UIAlertController(title: "Do you wish to change your Password?", message: " ", preferredStyle: .Alert)
                let settingsAlertAction = UIAlertAction(title: "Confirm", style: .Default, handler: { (_) -> Void in
                    
                    UserController.updateUser(self.user, username: self.user.username , phoneNumber: self.user.phoneNumber, password: self.newPasswordTextField.text, completion: { (success, user) -> Void in
                        
                        self.performSegueWithIdentifier("savedFromSettings", sender: nil)
                    })
                    
                    
                })
                
            
                settingsAlert.addAction(settingsAlertAction)
                
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
