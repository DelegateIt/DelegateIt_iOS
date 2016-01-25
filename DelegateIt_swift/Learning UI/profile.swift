//
//  profile.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/10/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//


import Foundation
import FBSDKLoginKit

class profile: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "TextCell"
    
    let blogSegueIdentifier = "ShowBlogSegue"   //New
    
    let swiftBlogs = ["EDIT PROFILE", "WORK WITH US", "ABOUT"]
    
    var choosenRow = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SETTINGS"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //New
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print(swiftBlogs[(tableView.indexPathForSelectedRow?.row)!])
        //print(segue.identifier)
        
        print(choosenRow)
        
        if(segue.identifier == "sample2"){
            let destination = segue.destinationViewController as! about
            destination.blogName = choosenRow
        }
        
        /*
        if segue.identifier == "sample2" {
            if let destination = segue.destinationViewController as? about {
                if let blogIndex = tableView.indexPathForSelectedRow {
                    destination.blogName = swiftBlogs[(tableView.indexPathForSelectedRow?.row)!]
                }
            }
        }
        else if swiftBlogs[(tableView.indexPathForSelectedRow?.row)!] == "ABOUT2" {
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("showAbout") as? about
            self.presentViewController(vc!, animated: true, completion: nil)
        }
        else if segue.identifier == blogSegueIdentifier {
            if let destination = segue.destinationViewController as? BlogViewController {
                if let blogIndex = tableView.indexPathForSelectedRow {
                    destination.blogName = swiftBlogs[(tableView.indexPathForSelectedRow?.row)!]
                }
            }
        }
        */
    }
    
    // MARK: - UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = swiftBlogs[row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print("--")
        //print(swiftBlogs[row])
        choosenRow = swiftBlogs[row]
        print("--")
        
        if(choosenRow == "ABOUT" || choosenRow == "WORK WITH US") {
            self.performSegueWithIdentifier("sample2", sender: self);
        }
        else {
            self.performSegueWithIdentifier("ShowBlogSegue", sender: self);
        }
        
        
    }
    
    
    @IBAction func LogoutUser(sender: AnyObject) {
        FBSDKLoginManager().logOut()
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

    func logout() {
        FBSDKLoginManager().logOut()
    }
    
    
    
}
