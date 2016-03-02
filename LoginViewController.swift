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


    @IBOutlet weak var touchIDButtonLabel: UIButton!

    @IBOutlet weak var cancelButtonLabel: UIButton!
    @IBOutlet weak var messLogo: UIButton!

    @IBOutlet weak var inPlainSight: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UIButton!

    var initialFrame: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.deviceRecognition()
        touchIDButtonLabel.hidden = true

    }

    override func viewWillAppear(animated: Bool) {
        animateView()
    }


    override func viewDidAppear(animated: Bool) {




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

        self.performSegueWithIdentifier("toInitialViewController", sender: nil)
    }


    @IBAction func forgotPasswordButtonTapped(sender: AnyObject) {


        let ref = Firebase(url: "https://messapp.firebaseio.com")
        ref.resetPasswordForUser(emailTextField.text!, withCompletionBlock: { error in
            if error != nil {

                self.textFieldInputErrorAlert("Unable to Complete Request", message: "\(error.localizedDescription)", textField: self.emailTextField)


            } else {

                self.textFieldInputConfirmationAlert("Email Sent!", message: "Check your email and follow the instructions.", textField: self.emailTextField)
            }
        })


    }

    @IBAction func enterButtonTapped(sender: AnyObject) {

        UserController.authenticateUser(emailTextField.text!, password:passwordTextField.text!, completion: { (success, user) -> Void in
            if success == true {

                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))


                self.performSegueWithIdentifier("toHomeViewFromLogin", sender: nil)

            } else {

                let incompleteLoginAlert = UIAlertController(title: "Unable to login user", message: "This user does not exist. ", preferredStyle: .Alert)
                let incompleteLoginAlertRedoAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in

                    self.passwordTextField.text = ""
                    self.textFieldInputError(self.passwordTextField)

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

    //MARK: TouchID Verification for user

    @IBAction func touchIDVerificationTapped(sender: AnyObject){

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.promptBiometricTouchID()
        })
    }

    func promptBiometricTouchID(){

        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:&error) {

            // evaluate

            let reason = "Authenticate"

            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: {
                (success: Bool, authenticationError: NSError?) -> Void in


                if success {

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                        print("succesful login with touch ID")

                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

                        self.performSegueWithIdentifier("toHomeViewFromLogin", sender: nil)

                    })


                } else {

                    print("\(authenticationError!.localizedDescription)")

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                        switch (authenticationError!.code) {
                        case LAError.AuthenticationFailed.rawValue:
                            self.promptUserPasswordAlert()
                            break;
                        case LAError.UserFallback.rawValue:
                            self.promptUserPasswordAlert()
                            break;
                        case LAError.UserCancel.rawValue:
                            break;

                        default:
                            break;
                        }


                    })


                }
            })
        }
    }

    // recognizing current device user

    func deviceRecognition(){

        let currentDeviceID = UIDevice.currentDevice().identifierForVendor?.UUIDString

        print(currentDeviceID)

        let ref = Firebase(url: "https://messapp.firebaseio.com/users")
        ref.queryOrderedByChild("deviceID").queryEqualToValue(currentDeviceID).observeEventType(.ChildAdded, withBlock: { snapshot in



            if let userDictionary = snapshot.value as? [String:String] {

                let user = User(json: userDictionary, identifier: snapshot.key)
                UserController.authenticateUser((user?.email)!, password: (user?.password)!, completion: { (success, user) -> Void in


                    self.touchIDButtonLabel.hidden = false


                })


            } else {



            }


        })



    }

    func promptUserPasswordAlert(){

        let passwordAlert = UIAlertController(title: "Enter Password", message: "Touch ID is not available on your device.", preferredStyle: .Alert)
        passwordAlert.addTextFieldWithConfigurationHandler { (passwordField) -> Void in

            passwordField.placeholder = "Password"
            passwordField.secureTextEntry = true

        }

        let passwordAlertCancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let passwordAlertAction = UIAlertAction(title: "Confirm", style: .Default) { (_) -> Void in

            if passwordAlert.textFields?[0].text == UserController.sharedController.currentUser.password {


                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

                self.performSegueWithIdentifier("toHomeViewFromLogin", sender: nil)



            }else{

                passwordAlert.textFields?[0].text = ""



            }

        }

        passwordAlert.addAction(passwordAlertAction)

        passwordAlert.addAction(passwordAlertCancelAction)

        presentViewController(passwordAlert, animated: true, completion: nil)
    }

    func textFieldInputConfirmed(textField: UITextField){



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

    func textFieldInputErrorAlert(title: String, message: String, textField: UITextField?){

        let textFieldError = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let textFieldErrorAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in

            if let textField = textField {

                self.textFieldInputError(textField)

            }

        }

        textFieldError.addAction(textFieldErrorAction)
        presentViewController(textFieldError, animated: true, completion: nil)

    }

    func textFieldInputConfirmationAlert(title: String, message: String, textField: UITextField?){

        let textFieldConfirmation = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let textFieldConfirmationAction = UIAlertAction(title: "OK", style: .Default) { (_) -> Void in

            if let textField = textField {

                self.textFieldInputConfirmed(textField)

            }

        }

        textFieldConfirmation.addAction(textFieldConfirmationAction)
        presentViewController(textFieldConfirmation, animated: true, completion: nil)
        
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
        self.cancelButtonLabel.center.x = -600
        self.forgotPasswordLabel.center.x = self.view.frame.height - 900
        self.touchIDButtonLabel.center.x = self.view.frame.height - 900


        UIView.animateWithDuration(1.0, delay: 0.75, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in

            self.emailTextField.center.x = self.view.frame.width / 2
            self.passwordTextField.center.x = self.view.frame.width / 2
            self.messLogo.center.x = self.view.frame.height / 3.5
            self.inPlainSight.center.x = self.view.frame.height / 3.5
            self.forgotPasswordLabel.center.x = self.view.frame.height / 3.5
            self.loginButton.center.x = 525
            self.cancelButtonLabel.center.x = -200
            self.touchIDButtonLabel.center.x = self.view.frame.height / 3.5
            
            }, completion: nil)
        
        
    }
    
    
}

