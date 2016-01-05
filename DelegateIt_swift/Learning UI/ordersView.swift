//
//  ordersView.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 12/23/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit

class ordersView: UITableViewController {
    var tableData = mainInstance.active_transaction_uuids //["Order1", "Order2", "Order3", "Order4"]
    
    var detailData = mainInstance.active_transaction_uuids //["Dec 21", "Dec 21", "Dec 21", "Dec 21"]
    
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        let detailViewController = segue.sourceViewController as! DetailTableViewController
        let changedPrice = detailViewController.priceString
        let index = detailViewController.index
        detailData[index!] = changedPrice!
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        tableData = mainInstance.active_transaction_uuids
        detailData = mainInstance.active_transaction_uuids
        print(mainInstance.active_transaction_uuids)
        super.viewDidLoad()
        self.title = "ORDERS"
        self.tabBarController?.tabBar.hidden = false
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
        if segue.identifier == "gotoOrder" {
            
            let path = tableView.indexPathForSelectedRow
            //sdfgsdfglet destination = segue.destinationViewController as! CustomOrder
            //destination.index = path?.row
            //destination.data = tableData
            //destination.price = detailData
            
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
}
