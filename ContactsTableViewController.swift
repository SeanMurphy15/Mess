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
        
        viewControllerAppearance()
        
         setupSearchController()
        
        UserController.fetchAllUsers { (users) -> Void in
            
            self.userDataSource = users
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tableView.reloadData()
            })
            
            
        }
        
        
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return userDataSource.count
        
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        
        let user = userDataSource[indexPath.row]
        
        // programmatic tableview colors
        
        tableView.backgroundColor = UIColor(red: 4/255, green: 197/255, blue: 255/255, alpha: 1.0)
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = UIColor(red: 4/255, green: 197/255, blue: 255/255, alpha: 1.0)
        } else {
            
            cell.backgroundColor = UIColor(red: 3/255, green: 158/255, blue: 204/255, alpha: 1.0)
            
        }
        
        
        cell.textLabel!.text = user.username
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        
        cell?.selectionStyle = .None
        
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchTerm = searchController.searchBar.text!.lowercaseString
        
        let resultsViewController = searchController.searchResultsController as! SearchResultsForUsersTableViewController
        
        resultsViewController.filteredUsers = userDataSource.filter({ $0.email.lowercaseString.containsString(searchTerm) })
        resultsViewController.tableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let user = userDataSource[indexPath.row]
                
                let detailView = segue.destinationViewController as! EncryptMessageViewController
                
                _ = detailView.view
                
                
                detailView.updateMessageReceiver(user)
                
            
        }
        
        
    }
    
    //MARK: Appearance
    
    //MARK: Set up Search Controller with animations
    
    func setupSearchController() {
        let resultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UserSearchResults")
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.barTintColor = UIColor(red: 4/255, green: 197/255, blue: 255/255, alpha: 1.0)
        searchController.searchBar.alpha = 0.0
        UISearchBar.animateWithDuration(2.0) { () -> Void in
            self.searchController.searchBar.alpha = 1.0
        }
        
        searchController.searchBar.placeholder = "Search Users"
        searchController.hidesNavigationBarDuringPresentation = true
        
        definesPresentationContext = true
    }
    
    //MARK: Animate tableview
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 0, 0)
        cell.layer.transform = rotationTransform
        UIView.animateWithDuration(1.0) { () -> Void in
            
            cell.layer.transform = CATransform3DIdentity
            
            
        }
        
    }
    
    
    func viewControllerAppearance(){
        
        // Make Navigation controller translucent and fade in
        
        
        navigationController?.navigationBar.alpha = 0.0
        
        UINavigationBar.animateWithDuration(2.0) { () -> Void in
            
            self.navigationController?.navigationBar.alpha = 1.0

            
        }
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
     
        
        
    }
    
    
    
    
}
