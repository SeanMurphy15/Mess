//
//  SettingsViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//  b92b59d3-af2c-44ee-b1dc-41858d1338c7

import UIKit
import Firebase
import DigitsKit

@IBDesignable

class SettingsViewController: UIViewController, UITextFieldDelegate {

    var user = UserController.sharedController.currentUser


    let userRef = Firebase(url: "https://messapp.firebaseio.com/users")

    @IBOutlet weak var deleteAccountButtonLabel: UIButton!
    @IBOutlet weak var logoutButtonLabel: UIButton!
    @IBOutlet weak var newPasswordTextField: UITextField!

    @IBOutlet weak var reEnterNewPasswordTextField: UITextField!

    @IBOutlet weak var newPhoneNumberTextField: UITextField!

    
    @IBOutlet weak var touchIDAuthButtonLabel: UIButton!
    @IBOutlet weak var currentUserTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        currentUserTextLabel.text = UserController.sharedController.currentUser.username

        Digits.sharedInstance().logOut()


    }

    override func viewWillAppear(animated: Bool) {

        animateView()
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()


    }




//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        if textField == newPhoneNumberTextField {
//
//            verifyPhone()
//
//            return false
//        }
//
//        return true
//    }



    func textFieldDidEndEditing(textField: UITextField){

        switch (textField == textField) {
        case textField == newPasswordTextField && newPasswordTextField.text?.characters.count > 0:
            textFieldInputConfirmed(newPasswordTextField)
            break;
            case textField == newPhoneNumberTextField:
            newPhoneNumberTextField.resignFirstResponder()
            break;
        case textField == reEnterNewPasswordTextField && reEnterNewPasswordTextField.text?.characters.count > 0:
            if reEnterNewPasswordTextField.text != newPasswordTextField.text {

                self.textFieldInputError(reEnterNewPasswordTextField)

            } else {

                self.textFieldInputConfirmed(reEnterNewPasswordTextField)

            }

            break;
        case textField == reEnterNewPasswordTextField && reEnterNewPasswordTextField.text != newPasswordTextField.text && reEnterNewPasswordTextField.text?.characters.count > 0 && newPasswordTextField.text?.characters.count > 0:
            textFieldInputError(reEnterNewPasswordTextField)
            textFieldInputError(newPasswordTextField)
            break;
        default:
            break;
        }


    }

    func textFieldDidBeginEditing(textField: UITextField) {

        switch (textField == textField) {
        case textField == newPhoneNumberTextField:
            newPhoneNumberTextField.layer.borderWidth = 0.0
            break;
        case textField == newPasswordTextField:
            newPasswordTextField.layer.borderWidth = 0.0
            break;
        case textField == reEnterNewPasswordTextField:

            reEnterNewPasswordTextField.layer.borderWidth = 0.0
            break;
        default:
            break;
        }


    }

    // aniations for confirmations / errors within text fields
    func textFieldInputConfirmed(textField: UITextField){

        // called by textFieldConfirmationAlert

        textField.layer.borderWidth = 2.5
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor.greenColor().CGColor
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(textField.center.x, textField.center.y - 10))
        animation.toValue = NSValue(CGPoint: CGPointMake(textField.center.x, textField.center.y + 10))
        textField.layer.addAnimation(animation, forKey: "position")


    }


    func textFieldInputError(textField: UITextField) {

        // called by textFieldErrorAlert

        textField.layer.borderWidth = 2.5
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor(red: 255/255, green: 29/255, blue: 96/255, alpha: 1.0).CGColor

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(textField.center.x - 10, textField.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(textField.center.x + 10, textField.center.y))
        textField.layer.addAnimation(animation, forKey: "position")
        textField.text = ""

    }

    //MARK: Reusable TextField Alerts

    func textFieldErrorAlert(title: String, message: String, textField: UITextField?){

        let textFieldError = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let textFieldErrorAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in

            if let textField = textField {

                self.textFieldInputError(textField)

            }

        }

        textFieldError.addAction(textFieldErrorAction)
        presentViewController(textFieldError, animated: true, completion: nil)

    }

    func textFieldConfirmationAlert(title: String, message: String, textField: UITextField?){

        let textFieldConfirmation = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let textFieldConfirmationAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in

            if let textField = textField {

                self.textFieldInputConfirmed(textField)

            }

        }

        textFieldConfirmation.addAction(textFieldConfirmationAction)
        presentViewController(textFieldConfirmation, animated: true, completion: nil)

    }



    //MARK: verify phone number for user signup

    func verifyPhone(){
        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        configuration.appearance = DGTAppearance()

        configuration.appearance.logoImage = UIImage(named: "messLogo-digits-logo")

        configuration.appearance.labelFont = UIFont(name: "HelveticaNeue-Bold", size: 16)
        configuration.appearance.bodyFont = UIFont(name: "HelveticaNeue-Bold", size: 16)

        configuration.appearance.accentColor = UIColor.whiteColor()
        configuration.appearance.backgroundColor = UIColor(red: 4/255, green: 197/255, blue: 255/255, alpha: 1.0)

        Digits.sharedInstance().authenticateWithViewController(self, configuration: configuration) { (session, error) -> Void in
            if (session != nil) {


                self.newPhoneNumberTextField.text = session.phoneNumber
                self.textFieldInputConfirmed(self.newPhoneNumberTextField)

                let message = "Phone number: \(session!.phoneNumber)"

                self.textFieldConfirmationAlert("Phone Number Authorized", message: message, textField: self.newPhoneNumberTextField)



            } else {

                self.textFieldErrorAlert("Error", message: "\(error.localizedDescription)", textField: self.newPhoneNumberTextField)
            }

        }

    }



    @IBAction func saveButtonTapped(sender: AnyObject) {



        saveSettings()



    }

    // alerts for changed properties of user

    func saveSettings() {

        if newPasswordTextField.text! != reEnterNewPasswordTextField.text! {


            self.textFieldErrorAlert("Passwords don't match!", message: "", textField: nil)

            textFieldInputError(self.reEnterNewPasswordTextField)
            textFieldInputError(self.newPasswordTextField)
            
            
            
        }


        if newPasswordTextField.text != "" && reEnterNewPasswordTextField.text != "" && reEnterNewPasswordTextField.text == newPasswordTextField.text && newPhoneNumberTextField.text == ""{

            let settingsAlert = UIAlertController(title: "Do you wish to change your Password?", message: " ", preferredStyle: .Alert)
            let cancelPasswordChange = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) -> Void in

                self.newPasswordTextField.text = ""
                self.reEnterNewPasswordTextField.text = ""

            })
            let settingsAlertAction = UIAlertAction(title: "Confirm", style: .Default, handler: { (_) -> Void in

                let ref = Firebase(url: "https://messapp.firebaseio.com")
                ref.changePasswordForUser(self.user.email, fromOld: self.user.password,
                    toNew: self.newPasswordTextField.text, withCompletionBlock: { error in
                        if error != nil {

                            self.textFieldErrorAlert("Unable to change passsword", message: "\(error.localizedDescription)", textField: nil)
                            self.textFieldInputError(self.newPasswordTextField)
                            self.textFieldInputError(self.reEnterNewPasswordTextField)

                        } else {
                            self.user.password = self.newPasswordTextField.text
                            self.user.save()
                            self.textFieldInputConfirmed(self.newPasswordTextField)
                            self.textFieldInputConfirmed(self.reEnterNewPasswordTextField)
                            self.newPasswordTextField.text = ""
                            self.reEnterNewPasswordTextField.text = ""


                        }
                })

            })


            settingsAlert.addAction(settingsAlertAction)
            settingsAlert.addAction(cancelPasswordChange)

            self.presentViewController(settingsAlert, animated: true, completion: nil)
        }

            if newPhoneNumberTextField.text != "" && newPasswordTextField.text == "" && reEnterNewPasswordTextField.text == "" {

                let settingsAlert = UIAlertController(title: "Do you wish to change your phone number?", message: "New phone number: \(newPhoneNumberTextField.text!)", preferredStyle: .Alert)
                let cancelPasswordChange = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) -> Void in

                    self.newPhoneNumberTextField.text = ""


                })
                let settingsAlertAction = UIAlertAction(title: "Confirm", style: .Default, handler: { (_) -> Void in

                    self.user.phoneNumber = self.newPhoneNumberTextField.text
                    self.user.save()
                    self.textFieldInputConfirmed(self.newPhoneNumberTextField)
                    self.newPhoneNumberTextField.text = ""


                })
                
                
                settingsAlert.addAction(settingsAlertAction)
                settingsAlert.addAction(cancelPasswordChange)
                
                self.presentViewController(settingsAlert, animated: true, completion: nil)

            }



        if newPhoneNumberTextField.text != "" && newPasswordTextField.text != "" && reEnterNewPasswordTextField.text != "" {


            let settingsAlert = UIAlertController(title: "Do you wish to make multiple changes?", message: "New phone number: \(newPhoneNumberTextField.text!) \nNew Pasword \(newPasswordTextField.text!)", preferredStyle: .Alert)
            let cancelPasswordChange = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) -> Void in

                self.newPhoneNumberTextField.text = ""
                self.newPasswordTextField.text = ""
                self.reEnterNewPasswordTextField.text = ""


            })

            let settingsAlertAction = UIAlertAction(title: "Confirm", style: .Default, handler: { (_) -> Void in

                self.user.phoneNumber = self.newPhoneNumberTextField.text
                self.user.save()
                self.textFieldInputConfirmed(self.newPhoneNumberTextField)
                self.newPhoneNumberTextField.text = ""


                let ref = Firebase(url: "https://messapp.firebaseio.com")
                ref.changePasswordForUser(UserController.sharedController.currentUser.email, fromOld: UserController.sharedController.currentUser.password,
                    toNew: self.newPasswordTextField.text, withCompletionBlock: { error in
                        if error != nil {

                            self.textFieldErrorAlert("Unable to change passsword", message: "\(error.localizedDescription)", textField: nil)
                            self.textFieldInputError(self.newPasswordTextField)
                            self.textFieldInputError(self.reEnterNewPasswordTextField)

                        } else {
                            self.user.password = self.newPasswordTextField.text
                            self.user.save()
                            self.textFieldInputConfirmed(self.newPasswordTextField)
                            self.textFieldInputConfirmed(self.reEnterNewPasswordTextField)
                            self.newPasswordTextField.text = ""
                            self.reEnterNewPasswordTextField.text = ""
                            
                            
                        }
                })


            })


            settingsAlert.addAction(settingsAlertAction)
            settingsAlert.addAction(cancelPasswordChange)

            self.presentViewController(settingsAlert, animated: true, completion: nil)



        }

    }





    //MARK: Delete Account with error handling alert

    @IBAction func deleteAccountButtonTapped(sender: AnyObject) {


        let settingsAlert = UIAlertController(title: "Are you sure you want to delete your account?", message: "This action can't be undone!", preferredStyle: .Alert)
        let settingsAlertCancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let settingsAlertAction = UIAlertAction(title: "Confirm", style: .Default, handler: { (_) -> Void in

            self.user.delete()

            self.performSegueWithIdentifier("toInitialViewController", sender: nil)

        })

        settingsAlert.addAction(settingsAlertAction)

        settingsAlert.addAction(settingsAlertCancelAction)

        self.presentViewController(settingsAlert, animated: true, completion: nil)


    }

    //Logout button tapped

    @IBAction func logoutButtonTapped(sender: AnyObject) {

        UserController.logoutCurrentUser()



        self.performSegueWithIdentifier("toLoginViewController", sender: nil)

    }

    // MARK: Animations

    func animateView(){

        // animate bar buttons into view

        self.newPasswordTextField.center.x = self.view.frame.width + 500
        self.reEnterNewPasswordTextField.center.x = self.view.frame.width - 500
        self.newPhoneNumberTextField.center.x = self.view.frame.width + 500
        self.touchIDAuthButtonLabel.center.x = self.view.frame.width - 500
        self.logoutButtonLabel.center.x = self.view.frame.height - 900
        self.deleteAccountButtonLabel.center.x = self.view.frame.height + 400
        self.currentUserTextLabel.center.x = self.view.frame.width - 500
        
        
        
        
        UIView.animateWithDuration(1.0, delay: 0.75, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
            
            self.newPasswordTextField.center.x = self.view.frame.width / 2
            self.reEnterNewPasswordTextField.center.x = self.view.frame.width / 2
            self.newPhoneNumberTextField.center.x = self.view.frame.width / 2
            self.touchIDAuthButtonLabel.center.x = self.view.frame.width / 2
            self.logoutButtonLabel.center.x = self.view.frame.height / 3.5
            self.deleteAccountButtonLabel.center.x = self.view.frame.height / 3.5
            self.currentUserTextLabel.center.x = self.view.frame.width / 2
            
            
            }, completion: nil)
        
        // Make Navigation bar translucent and fades in
        
        navigationController?.navigationBar.alpha = 0.0
        
        UINavigationBar.animateWithDuration(2.5) { () -> Void in
            
            self.navigationController?.navigationBar.alpha = 1.0
            
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        
    }
    
}

