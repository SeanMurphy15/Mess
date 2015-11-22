//
//  EncryptMessageViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit

class EncryptMessageViewController:


    UIViewController {
    
    @IBOutlet weak var messageReceiverTextLabel: UILabel!
    
   
    @IBOutlet weak var originalMessageTextView: UITextView!

    
    var messageRecieverTextLabelData: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        messageReceiverTextLabel.text = self.messageRecieverTextLabelData
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MARK: Buttons
    
    
    @IBAction func trashButtonTapped(sender: AnyObject) {
        
        originalMessageTextView.text.removeAll()
    }
    
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            return
        }
        
    }
    
    
    
    @IBAction func encryptMessageButtonTapped(sender: AnyObject) {
    
   
    
    }
    
        
    
    
    
    
   
}
