//
//  AlertController.swift
//  Mess
//
//  Created by Sean Murphy on 12/20/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit

class AlertController: UIViewController {

    static let sharedController = AlertController()


     func equalUsernameAlert(){

        let equalUsernameAlert = UIAlertController(title: "This username is already in use!", message: "", preferredStyle: .Alert)
        let equalUsernameAlertAction = UIAlertAction(title: "Enter Password", style: .Default) { (_) -> Void in

            LoginSignupViewController.
        }

        equalUsernameAlert.addAction(equalUsernameAlertAction)
        presentViewController(equalUsernameAlert, animated: true, completion: nil)

    }


}
