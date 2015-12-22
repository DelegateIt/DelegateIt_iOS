//
//  MainTableViewController.swift
//  edit data demo
//
//  Created by Apoorv Mote on 04/10/15.
//  Copyright © 2015 Apoorv Mote. All rights reserved.
//

import UIKit

class editUserProfile: UITableViewController {

    var tableData = ["FIRST NAME", "LAST NAME", "EMAIL", "PHONE NUMBER"]
    
    var detailData = ["Ben", "Wernsman", "ben.wernsman@me.com", "214-478-7761"]
    
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        let detailViewController = segue.sourceViewController as! DetailTableViewController
        let changedPrice = detailViewController.priceString
        let index = detailViewController.index
        detailData[index!] = changedPrice!
        tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PROFILE"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        // Configure the cell...
        cell.textLabel?.text = tableData[indexPath.row]
        cell.detailTextLabel?.text = detailData[indexPath.row]
        return cell
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit" {
            
            let path = tableView.indexPathForSelectedRow
            let destination = segue.destinationViewController as! DetailTableViewController
            destination.index = path?.row
            destination.data = tableData
            destination.price = detailData
            
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
}
