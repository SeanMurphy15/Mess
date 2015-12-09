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
