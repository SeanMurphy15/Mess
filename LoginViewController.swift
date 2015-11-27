//
//  LoginViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/27/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var user: User?
    
    func updateWithUser(user: User) {
        self.user = user
    }
    
    @IBAction func enterButtonTapped(sender: AnyObject) {
        
        UserController.authenticateUser(emailTextField.text!, password: passwordTextField.text!, completion: { (success, user) -> Void in
            if success == true{
                
                _ = user
                
                self.performSegueWithIdentifier("toHomeViewFromLogin", sender: nil)
            
            } else {
                
                print("Not a matching user")
            }
        })
        
        
    }

    @IBAction func touchIDButtonTapped(sender: AnyObject) {
        
        promptBiometricTouchIDForLogin()
        
    }
    
    
    func promptBiometricTouchIDForLogin(){
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself"
            
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] (success: Bool, authenticationError: NSError?) in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if success == true {
                        
                        
                        self.performSegueWithIdentifier("toHomeViewFromLogin", sender: nil)
                        
                        print("Authorized")

                        
                        
                        }else{
                        
                        
                        print("not Authorized")
                    }
                }
            }
        }
        
    }
}
