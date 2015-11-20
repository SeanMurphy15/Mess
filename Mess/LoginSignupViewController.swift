//
//  LoginSignupViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit
import Firebase

class LoginSignupViewController: UIViewController{
    
    
    @IBOutlet weak var usernameTextField: UITextField!
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
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        
        
        //MARK: - Error handle unequal passwords
        //MARK: - Create new user
        
        
    if !usernameTextField.text!.isEmpty && !phoneNumberTextField.text!.isEmpty && passwordTextField.text == reEnterPasswordTextField.text && !passwordTextField.text!.isEmpty && !reEnterPasswordTextField.text!.isEmpty{
            
        let userDictionary = ["username": usernameTextField.text!, "password": passwordTextField.text!, "phoneNumber": phoneNumberTextField.text!]
        
        UserController.sharedController.addUser(User(dictionary: userDictionary))
        
        UserController.sharedController.saveUserToFirebase()
        
        
        
        } else if passwordTextField.text! != reEnterPasswordTextField.text! {
            
            let passwordAlert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .ActionSheet)
            let redoPasswordAction = UIAlertAction(title: "Redo", style: .Default) { (_) -> Void in
                
                self.resetPasswordTextFields()
                
            }
            
            passwordAlert.addAction(redoPasswordAction)
            
            presentViewController(passwordAlert, animated: true, completion: nil)
            
            
        }else{
            
            let incompleteSignupAlert = UIAlertController(title: "Incomplete Submission", message: "You have not filled in all the boxes", preferredStyle: .ActionSheet)
            let incompleteSignupAlertRedoAction = UIAlertAction(title: "Redo", style: .Default) { (_) -> Void in
                
            }
            
            incompleteSignupAlert.addAction(incompleteSignupAlertRedoAction)
            
            presentViewController(incompleteSignupAlert, animated: true, completion: nil)
            
        }
        
        
        
        
        
    }
    
    
    
}
