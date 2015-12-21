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

    static let sharedController = LoginSignupViewController()

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


    override func viewWillAppear(animated: Bool) {

        animateView()
    }
    @IBAction func cancelButtonTapped(sender: AnyObject) {

        self.dismissViewControllerAnimated(true, completion: nil)
    }

//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        if textField == phoneNumberTextField {
//
//            verifyPhone()
//
//            return false
//        }
//
//         return true
//    }


    func textFieldDidEndEditing(textField: UITextField){

        switch (textField == textField) {
        case textField == usernameTextField && usernameTextField.text?.characters.count > 0:
            textFieldInputConfirmed(usernameTextField)
            //findEqualUsernames(self.usernameTextField.text!, textField: self.usernameTextField)
            break;
        case textField == emailTextField && emailTextField.text?.characters.count > 0:
            textFieldInputConfirmed(emailTextField)
            //findEqualUserEmails(self.emailTextField.text!, textField: self.emailTextField)
            break;
        case textField == phoneNumberTextField && phoneNumberTextField.text?.characters.count > 0:
            textFieldInputConfirmed(phoneNumberTextField)
            break;
        case textField == passwordTextField && passwordTextField.text?.characters.count > 0:
            textFieldInputConfirmed(passwordTextField)
            break;
        case textField == reEnterPasswordTextField && reEnterPasswordTextField.text?.characters.count > 0:
            textFieldInputConfirmed(reEnterPasswordTextField)
            break;

        default:
            break;
        }


    }

    func textFieldDidBeginEditing(textField: UITextField) {

        switch (textField == textField) {
        case textField == phoneNumberTextField:

            //verifyPhone()

            break;
        case textField == usernameTextField:
            usernameTextField.layer.borderWidth = 0.0
            break;
        case textField == emailTextField:
            emailTextField.layer.borderWidth = 0.0
            break;
        case textField == passwordTextField:

            passwordTextField.layer.borderWidth = 0.0
            break;
        case textField == reEnterPasswordTextField:

            reEnterPasswordTextField.layer.borderWidth = 0.0
            break;
        default:
            break;
        }


    }
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

    //MARK: Universal TextField Alerts

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


                self.phoneNumberTextField.text = session.phoneNumber

                let message = "Phone number: \(session!.phoneNumber)"

                self.textFieldConfirmationAlert("Phone Number Authorized", message: message, textField: self.phoneNumberTextField)



            } else {

                self.textFieldErrorAlert("Error", message: "\(error.localizedDescription)", textField: self.phoneNumberTextField)
            }

        }

    }

    
     func findEqualUserEmails(email: String, textField: UITextField){


        let ref = Firebase(url: "https://messapp.firebaseio.com/users")
        ref.queryOrderedByChild("email").queryEqualToValue(email).observeEventType(.Value, withBlock: { snapshot in


            if snapshot.exists(){

                let userDictionary = snapshot.value as? [String:String]

                let user = User(json: userDictionary!, identifier: snapshot.key)

                if user?.email == email {

                    //self.textFieldErrorAlert("\(email) is already in use!", message: "try another one!", textField: textField)
                    self.textFieldInputError(self.emailTextField)

                } else {



                }



            } else {



            }




        })


    }

    func findEqualUsernames(username: String, textField: UITextField){


        let ref = Firebase(url: "https://messapp.firebaseio.com/users")
        ref.queryOrderedByChild("username").queryEqualToValue(username).observeEventType(.Value, withBlock: { snapshot in


            if snapshot.exists(){

                let userDictionary = snapshot.value as? [String:String]

                let user = User(json: userDictionary!, identifier: snapshot.key)

                if user?.username == username {
                    
                    //self.textFieldErrorAlert("\(username) is already in use!", message: "try another one!", textField: textField)
                    self.textFieldInputError(self.usernameTextField)

                } else {
                    
                    
                    
                }
                
                
                
            } else {
                
                
                
            }
            
            
            
            
        })
        
        
    }
    
    
    




    //MARK: Signup Button tapped
    @IBAction func signupButtonTapped(sender: AnyObject) {

        if let email = emailTextField.text {

        self.findEqualUserEmails(email, textField: emailTextField)
        }
        if let username = usernameTextField.text {

            self.findEqualUsernames(username, textField: emailTextField)
        }



        if !emailTextField.text!.isEmpty && !phoneNumberTextField.text!.isEmpty && !usernameTextField.text!.isEmpty  && passwordTextField.text == reEnterPasswordTextField.text && !passwordTextField.text!.isEmpty && !reEnterPasswordTextField.text!.isEmpty {

            let deviceID = UIDevice.currentDevice().identifierForVendor?.UUIDString

            UserController.createUser(emailTextField.text!, password: passwordTextField.text!, phoneNumber: phoneNumberTextField.text!, username: usernameTextField.text!, deviceID: deviceID, completion: { (success, var user, error) -> Void in


                if success {
                    user?.save()

                    self.performSegueWithIdentifier("toLoginFromSignup", sender: nil)


                } else {
                    if let error = error {

                        self.textFieldErrorAlert("Access Denied", message: "\(error.localizedDescription)", textField: nil)
                    }

                }
            })

        }

        if passwordTextField.text! != reEnterPasswordTextField.text! {


     self.textFieldErrorAlert("Passwords don't match!", message: "", textField: nil)

            textFieldInputError(self.reEnterPasswordTextField)
            textFieldInputError(self.passwordTextField)



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

//switch (error == error) {
//case self.passwordTextField.text != self.reEnterPasswordTextField.text:
//    self.textFieldErrorAlert("Passwords do not match", message: "", textField: self.passwordTextField)
//    self.textFieldInputError(self.reEnterPasswordTextField)
//    break;
//case self.phoneNumberTextField.text == "":
//    self.textFieldErrorAlert("Phone Number is required", message: "", textField: self.phoneNumberTextField)
//    break;
//case self.phoneNumberTextField.text?.characters.count < 10:
//    self.textFieldErrorAlert("Not a valid phone number", message: "Please provide another phone number", textField: self.phoneNumberTextField)
//    break;
//
//default:
//
//    self.textFieldErrorAlert("Something went wrong!", message: "\(error?.localizedDescription)", textField: nil)
//    break;
//
