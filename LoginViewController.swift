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
        //emailTextField.text!
        //passwordTextField.text
        UserController.authenticateUser(emailTextField.text!, password:passwordTextField.text!, completion: { (success, user) -> Void in
            if success == true {
                
                print("current user: \(UserController.sharedController.currentUser)")
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                self.performSegueWithIdentifier("toHomeViewFromLogin", sender: nil)
                
            } else {
                
                print("Not a matching user")
            }
        })
        
        
    }
    
    //MARK: Animations
    
    func animate(){
        
        
        
    }
    
    
}
