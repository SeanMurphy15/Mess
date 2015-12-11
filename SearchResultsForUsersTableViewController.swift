//
//  SearchResultsForUsersTableViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/19/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit

class SearchResultsForUsersTableViewController: UITableViewController {
    
    var filteredUsers = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  filteredUsers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        let user = filteredUsers[indexPath.row]
        
        tableView.backgroundColor = UIColor(red: 4/255, green: 197/255, blue: 255/255, alpha: 1.0)
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = UIColor(red: 4/255, green: 197/255, blue: 255/255, alpha: 1.0)
        } else {
            
            cell.backgroundColor = UIColor(red: 3/255, green: 158/255, blue: 204/255, alpha: 1.0)
            
        }
        
        cell.textLabel?.text = user.email
        
        return cell
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let filteredUsersFromSearch = filteredUsers[indexPath.row]
                
                let detailView = segue.destinationViewController as! EncryptMessageViewController
                
                _ = detailView.view
                
                detailView.updateMessageReceiver(filteredUsersFromSearch)
            
        }
        
        
    }


}
