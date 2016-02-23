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
    @IBOutlet weak var blueDot: UIImageView!
    
    var tableData:[String] = []
    
    var detailData:[String] = []
    
    var UUIDs:[String] = []
    
    
    
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        let detailViewController = segue.sourceViewController as! DetailTableViewController
        let changedPrice = detailViewController.priceString
        let index = detailViewController.index
        detailData[index!] = changedPrice!
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        replyBtn.setImage(UIImage(named: "profileIcon.png"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: Selector("gotoSettings:"), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
        
        loadTable()
        
        self.title = "ORDERS"
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    func loadTable(){
        self.tableData = []
        self.detailData = []
        self.UUIDs = []
        var date = NSDate().timeIntervalSince1970
        date *= 1000000
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM d"
        
        let hourFormat = NSDateFormatter()
        hourFormat.dateFormat = "h:mm a"
        
        mainInstance.sortTransaction()
        
        var index = 0
        for (index = 0; index < mainInstance.active_transaction_uuids2.count; index++){
            if(mainInstance.active_transaction_uuids2[index].paymentStatus == "proposed"){
                tableData.append("RECEIPT")
            }
            else{
                tableData.append(mainInstance.active_transaction_uuids2[index].lastMessage)
            }
            
            UUIDs.append(mainInstance.active_transaction_uuids2[index].transactionUUID)
            
            let day = NSDate(timeIntervalSince1970:mainInstance.active_transaction_uuids2[index].lastTimeStamp/1000000)
            var dateString = ""
            
            if(date - mainInstance.active_transaction_uuids2[index].lastTimeStamp < 86400000000){
                 dateString = hourFormat.stringFromDate(day)
            }
            else{
                 dateString = dayTimePeriodFormatter.stringFromDate(day)
            }
            detailData.append(dateString)
        }
        
        self.tableView.reloadData()
    }
    
    func gotoSettings(sender:UIButton!){
        self.performSegueWithIdentifier("goToSettings23", sender: self);
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
    }
    
    func loadList(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.loadTable()
        })
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
        cell.textLabel?.text = tableData[indexPath.row]
        cell.detailTextLabel?.text = detailData[indexPath.row]
        return cell
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoOrder" {
            let path = tableView.indexPathForSelectedRow
            let destination = segue.destinationViewController as! orderMessenger
            destination.data = UUIDs[(path?.row)!]
        }
    }
    
}
