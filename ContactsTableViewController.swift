//
//  ContactsTableViewController.swift
//  Mess
//
//  Created by Sean Murphy on 11/16/15.
//  Copyright © 2015 Sean Murphy. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    
    var userDataSource: [User] = []
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UserController.fetchAllUsers { (users) -> Void in
            
            self.userDataSource = users
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tableView.reloadData()
            })
            
            
        }
        
        setupSearchController()
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return userDataSource.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        
        let user = userDataSource[indexPath.row]
        
        cell.textLabel!.text = user.email
        //cell.detailTextLabel!.text = user.phoneNumber
        
        
        
        return cell
    }
    
    func setupSearchController() {
        let resultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UserSearchResults")
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchTerm = searchController.searchBar.text!.lowercaseString
        
        let resultsViewController = searchController.searchResultsController as! SearchResultsForUsersTableViewController
        
        resultsViewController.filteredUsers = userDataSource.filter({ $0.email.lowercaseString.containsString(searchTerm) })
        resultsViewController.tableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            return
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toMessageReceiversLabel"{
            
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let user = userDataSource[indexPath.row]
                
                let detailView = segue.destinationViewController as! EncryptMessageViewController
                
                _ = detailView.view
                
                detailView.updateMessageReceiver(user)
            }
            
            
        }
        
        
    }
    
    
}
