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
    var tableData:[String] = []//mainInstance.active_transaction_uuids //["Order1", "Order2", "Order3", "Order4"]
    
    var detailData:[String] = []//mainInstance.active_transaction_uuids //["Dec 21", "Dec 21", "Dec 21", "Dec 21"]
    
    var UUIDs:[String] = []
    
    
    
    @IBAction func saveToMainViewController (segue:UIStoryboardSegue) {
        let detailViewController = segue.sourceViewController as! DetailTableViewController
        let changedPrice = detailViewController.priceString
        let index = detailViewController.index
        detailData[index!] = changedPrice!
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        //let date = NSDate().timeIntervalSince1970
        //var date = NSDate()
        
        //var timestamp = UInt64(floor(date.timeIntervalSince1970 * 1000))
        
       // print((date * 1000000)-1453158484569111)
        
       // let day = NSDate(timeIntervalSince1970: date)
       // print(day)
        
        /*
        
        let morningOfChristmasComponents = NSDateComponents()
        morningOfChristmasComponents.year = 2014
        morningOfChristmasComponents.month = 12
        morningOfChristmasComponents.day = 25
        morningOfChristmasComponents.hour = 7
        morningOfChristmasComponents.minute = 0
        morningOfChristmasComponents.second = 0
        
        let morningOfChristmas = NSCalendar.currentCalendar().dateFromComponents(morningOfChristmasComponents)!

        */
        
        let date = NSDate()
        //let formatter = NSDateFormatter()
        //formatter.dateStyle = NSDateFormatterStyle.LongStyle
        //formatter.timeStyle = .MediumStyle
        
        //let dateString = formatter.stringFromDate(date)
        
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM d"
        
        let dateString = dayTimePeriodFormatter.stringFromDate(date)
        
        
        
        
        
        
        print(dateString)
        
        //print(dateString.d)
        
        
        
        var index = 0
        for (index = 0; index < mainInstance.active_transaction_uuids2.count; index++){
            tableData.append(mainInstance.active_transaction_uuids2[index].lastMessage)
            UUIDs.append(mainInstance.active_transaction_uuids2[index].transactionUUID)
            print(mainInstance.active_transaction_uuids2[index].lastMessage)
            
            
            let day = NSDate(timeIntervalSince1970:mainInstance.active_transaction_uuids2[index].lastTimeStamp/1000000)
            
            let dateString = dayTimePeriodFormatter.stringFromDate(day)
            
            detailData.append(dateString)
        }
        
        //tableData = mainInstance.active_transaction_uuids
        //detailData = mainInstance.active_transaction_uuids
        super.viewDidLoad()
        self.title = "ORDERS"
        self.tabBarController?.tabBar.hidden = false
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        
    
    }
    
    func loadList(notification: NSNotification){
        //load data here
        //self.tableView.reloadData()
        
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            print("updated")
            //self.tableData = mainInstance.active_transaction_uuids
            //self.detailData = mainInstance.active_transaction_uuids
            
            self.tableData = []
            self.detailData = []
            
            let date = NSDate()
            
            
            let dayTimePeriodFormatter = NSDateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM d"
            
            let dateString = dayTimePeriodFormatter.stringFromDate(date)
            
            var index = 0
            for (index = 0; index < mainInstance.active_transaction_uuids2.count; index++){
                
                
                
                let day = NSDate(timeIntervalSince1970:mainInstance.active_transaction_uuids2[index].lastTimeStamp/1000000)
                
                let dateString = dayTimePeriodFormatter.stringFromDate(day)
                
                if(index != 0 && mainInstance.active_transaction_uuids2[index].lastTimeStamp > mainInstance.active_transaction_uuids2[index-1].lastTimeStamp){
                    self.tableData.insert(mainInstance.active_transaction_uuids2[index].lastMessage,atIndex: 0)
                    self.detailData.insert(dateString, atIndex: 0)
                }else{
                    self.tableData.append(mainInstance.active_transaction_uuids2[index].lastMessage)
                    self.detailData.append(dateString)
                }
                
            }
            self.tableView.reloadData()
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
        // Configure the cell...
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
            //destination.price = detailData
            
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
}
