//
//  SettingsViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import Firebase

@IBDesignable

class SettingsViewController: UIViewController {
    
    var user = UserController.sharedController.currentUser

    @IBOutlet weak var deleteAccountButtonLabel: UIButton!
    @IBOutlet weak var logoutButtonLabel: UIButton!
    @IBOutlet weak var newPasswordTextField: UITextField!
   
    @IBOutlet weak var reEnterNewPasswordTextField: UITextField!
    
    @IBOutlet weak var newPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var reEnterNewPhoneNumberTextField: UITextField!
    @IBOutlet weak var currentUserTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setCurrentUser()

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        animateView()
    }
    
    func setCurrentUser(){
        
        currentUserTextLabel.text = UserController.sharedController.currentUser.username
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
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

    
    // Change password and confirm password change with firebase
    
    
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
        
        // save phone settings if textFields are populated and alert warning
        
        if !newPhoneNumberTextField.text!.isEmpty && !reEnterNewPhoneNumberTextField.text!.isEmpty && newPhoneNumberTextField.text == reEnterNewPhoneNumberTextField.text {
            
            
            let settingsAlert = UIAlertController(title: "Do you wish to change your Phone Number?", message: "", preferredStyle: .Alert)
            let settingsAlertAction = UIAlertAction(title: "Confirm", style: .Default, handler: { (_) -> Void in
                
                self.user.phoneNumber = self.newPhoneNumberTextField.text
                
                self.user.save()
                
                
                self.performSegueWithIdentifier("savedFromSettings", sender: nil)
                
            })
            
            settingsAlert.addAction(settingsAlertAction)
            
            self.presentViewController(settingsAlert, animated: true, completion: nil)
            
            
            
            
        }
        
    }
    
    
    //MARK: Delete Account with error handling alert
    
    @IBAction func deleteAccountButtonTapped(sender: AnyObject) {
        
        
        let settingsAlert = UIAlertController(title: "Are you sure you want to delete your account?", message: "This action can't be undone!", preferredStyle: .Alert)
        let settingsAlertCancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let settingsAlertAction = UIAlertAction(title: "Confirm", style: .Default, handler: { (_) -> Void in
            
            self.deAnimateView()
            
            self.user.delete()
            
            self.performSegueWithIdentifier("toInitialViewController", sender: nil)
            
        })
        
        settingsAlert.addAction(settingsAlertAction)
        
        settingsAlert.addAction(settingsAlertCancelAction)
    
        self.presentViewController(settingsAlert, animated: true, completion: nil)

        
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        UserController.logoutCurrentUser()
        
        deAnimateView()
        
        self.performSegueWithIdentifier("toInitialViewController", sender: nil)
        
    }
    
// MARK: Animations
    
    func animateView(){
        
        // animate bar buttons into view
        
        self.newPasswordTextField.center.x = self.view.frame.width + 500
        self.reEnterNewPasswordTextField.center.x = self.view.frame.width - 500
        self.newPhoneNumberTextField.center.x = self.view.frame.width + 500
        self.reEnterNewPhoneNumberTextField.center.x = self.view.frame.width - 500
        self.logoutButtonLabel.center.x = self.view.frame.height - 900
        self.deleteAccountButtonLabel.center.x = self.view.frame.height + 400
        self.currentUserTextLabel.center.x = self.view.frame.width - 500

        
        
        
        UIView.animateWithDuration(2.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            self.newPasswordTextField.center.x = self.view.frame.width / 2
            self.reEnterNewPasswordTextField.center.x = self.view.frame.width / 2
            self.newPhoneNumberTextField.center.x = self.view.frame.width / 2
            self.reEnterNewPhoneNumberTextField.center.x = self.view.frame.width / 2
            self.logoutButtonLabel.center.x = self.view.frame.height / 3.5
            self.deleteAccountButtonLabel.center.x = self.view.frame.height / 3.5
            self.currentUserTextLabel.center.x = self.view.frame.width / 2

            
            }, completion: nil)
        
        // Make Navigation bar translucent and fades in
        
        navigationController?.navigationBar.alpha = 0.0
        
        UINavigationBar.animateWithDuration(2.5) { () -> Void in
            
            self.navigationController?.navigationBar.alpha = 1.0
            
        }
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
    }
    
    func deAnimateView(){
        
        
        // deanimate the bar buttons to leave scene when pressed
        
        self.newPasswordTextField.center.x = self.view.frame.width / 2
        self.reEnterNewPasswordTextField.center.x = self.view.frame.width / 2
        self.newPhoneNumberTextField.center.x = self.view.frame.width / 2
        self.reEnterNewPhoneNumberTextField.center.x = self.view.frame.width / 2
        self.logoutButtonLabel.center.x = self.view.frame.height / 3.5
        self.deleteAccountButtonLabel.center.x = self.view.frame.height / 3.5
        self.currentUserTextLabel.center.x = self.view.frame.width / 2

        
        
        
        UIView.animateWithDuration(2.0, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            self.newPasswordTextField.center.x = self.view.frame.width + 500
            self.reEnterNewPasswordTextField.center.x = self.view.frame.width - 500
            self.newPhoneNumberTextField.center.x = self.view.frame.width + 500
            self.reEnterNewPhoneNumberTextField.center.x = self.view.frame.width - 500
            self.logoutButtonLabel.center.x = self.view.frame.height - 900
            self.deleteAccountButtonLabel.center.x = self.view.frame.height + 400
            self.currentUserTextLabel.center.x = self.view.frame.width - 500

            
            }, completion: nil)
        
    }

    
    
    
 
   }
