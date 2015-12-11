//
//  HomeViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
   
    @IBOutlet weak var inPlainSight: UIButton!
    @IBOutlet weak var messLogo: UIButton!
    
    @IBOutlet weak var encryptButtonLabel: UIButton!
    
    @IBOutlet weak var decryptButtonLabel: UIButton!
    
    
    @IBOutlet weak var settingsButtonLabel: UIButton!
    
    
    @IBOutlet weak var contactsButtonLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        animateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func settingsButton(sender: AnyObject) {
        
        deAnimateView()
    }
    
    @IBAction func contactsButton(sender: AnyObject) {
        
        deAnimateView()
    }
    @IBAction func encryptButton(sender: AnyObject) {
        
        deAnimateView()
    }
    @IBAction func decryptButton(sender: AnyObject) {
        
        deAnimateView()
    }
    
    
    
    func animateView(){
        
        self.encryptButtonLabel.center.x = self.view.frame.width - 450
        self.decryptButtonLabel.center.x = self.view.frame.width + 300
        self.settingsButtonLabel.center.x = self.view.frame.width + 300
        self.contactsButtonLabel.center.x = self.view.frame.width - 450
        self.messLogo.center.x = self.view.frame.height + 500
        self.inPlainSight.center.x = self.view.frame.height - 900
        
        
        
        
        UIView.animateWithDuration(2.0, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            self.encryptButtonLabel.center.x = self.view.frame.width / 2
            self.decryptButtonLabel.center.x = self.view.frame.width / 2
            self.settingsButtonLabel.center.x = self.view.frame.width / 2
            self.contactsButtonLabel.center.x = self.view.frame.width / 2
            self.messLogo.center.x = self.view.frame.height / 3.5
            self.inPlainSight.center.x = self.view.frame.height / 3.5
            
            
            }, completion: nil)
        
    
        
    }
    
    
    func deAnimateView(){
        
        self.encryptButtonLabel.center.x = self.view.frame.width / 2
        self.decryptButtonLabel.center.x = self.view.frame.width / 2
        self.settingsButtonLabel.center.x = self.view.frame.width / 2
        self.contactsButtonLabel.center.x = self.view.frame.width / 2
        self.messLogo.center.x = self.view.frame.height / 3.5
        self.inPlainSight.center.x = self.view.frame.height / 3.5

        
        
        
        UIView.animateWithDuration(2.0, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            
            
            
            self.encryptButtonLabel.center.x = self.view.frame.width - 450
            self.decryptButtonLabel.center.x = self.view.frame.width + 300
            self.settingsButtonLabel.center.x = self.view.frame.width + 300
            self.contactsButtonLabel.center.x = self.view.frame.width - 450
            self.messLogo.center.x = self.view.frame.height + 500
            self.inPlainSight.center.x = self.view.frame.height - 900
         
            
            }, completion: nil)
        
        
    }
    
}
