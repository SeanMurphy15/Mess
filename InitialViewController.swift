//
//  InitialViewController.swift
//  Mess
//
//  Created by Sean Murphy on 12/8/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    
    @IBOutlet weak var messLogo: UIButton!
    
    @IBOutlet weak var inPlainSight: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var createAccountLabel: UIButton!
    
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
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        
    }
    
    @IBAction func createAccountButtonTapped(sender: AnyObject) {
        
        
    }
    
    
    //MARK: Animation
    
    func animateView(){
        
        
        self.createAccountLabel.center.x = self.view.frame.width - 800
        self.loginButton.center.x = self.view.frame.width + 300
        self.messLogo.center.x = self.view.frame.height + 300
        self.inPlainSight.center.x = self.view.frame.height + 500
        
        
        
        UIView.animateWithDuration(1.0, delay: 0.75, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
            
            self.createAccountLabel.center.x = self.view.frame.width / 2
            self.loginButton.center.x = self.view.frame.width / 8
            self.messLogo.center.x = self.view.frame.height / 2
            self.inPlainSight.center.x = self.view.frame.height / 2
            
            }, completion: nil)
        
        
    }
    
    
}

