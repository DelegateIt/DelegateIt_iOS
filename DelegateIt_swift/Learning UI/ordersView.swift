//
//  ordersView.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 12/23/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit
import Google

class ordersView: UITableViewController {
    
    var tableData:[[String]] = [[],[]]
    var detailData:[[String]] = [[],[]]
    var UUIDs:[String] = []
    
    var sampleList:[Int] = [2,6]
    
    var completed:Int = 0
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Orders")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        mainInstance.autoDismiss = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let helpBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        helpBtn.setImage(UIImage(named: "help.png"), forState: UIControlState.Normal)
        helpBtn.addTarget(self, action: Selector("gotoTutorial:"), forControlEvents:  UIControlEvents.TouchUpInside)
        let item2 = UIBarButtonItem(customView: helpBtn)
        self.navigationItem.leftBarButtonItem = item2
        
        
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        replyBtn.setImage(UIImage(named: "profileIcon.png"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: #selector(ordersView.gotoSettings(_:)), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
        
        if(mainInstance.active_transaction_uuids2.count == 0){
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let label = UILabel(frame: CGRectMake(0, 0, 300, 300))
            label.center = CGPointMake(screenSize.width/2, 60)
            label.textAlignment = NSTextAlignment.Center
            label.text = "You haven’t placed an order yet.\nLet’s change that:"
            label.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
            label.numberOfLines = 2
            self.view.addSubview(label)
            
            let button = UIButton(type: UIButtonType.System) as UIButton
            button.frame = CGRectMake((screenSize.width-(screenSize.width/1.2))/2, 120, screenSize.width/1.2, 50)
            button.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
            button.setTitle("MAKE A NEW ORDER", forState: .Normal)
            button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.addTarget(self, action: #selector(ordersView.btnTouched(_:)), forControlEvents:.TouchUpInside)
            self.view.addSubview(button)
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            tableView.alwaysBounceVertical = false;
            
        }
        else{
            loadTable()
        }
        
        self.title = "Orders"
        print("show tab bar")
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x:40, y: 20, width: 50, height: 50))
        label.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        if(section == 0){
            label.text = " In Progress"
        }
        else{
            label.text = " Completed"
        }
        
        label.textColor = UIColor.whiteColor()
        view.addSubview(label)
        return label
    }
    
    func gotoTutorial(sender:UIButton!){
        print("Going to settings")
        //self.tabBarController?.hidesBottomBarWhenPushed = false
        //self.tabBarController?.tabBar.hidden = true
        self.performSegueWithIdentifier("showTutorial", sender: self);
        
    }
 
 
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    /*
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "In Progress"
    }
    */
    
    func loadTable(){
        print("loading table")
        self.tableData = [[],[]]
        self.detailData = [[],[]]
        self.UUIDs = []
        var date = NSDate().timeIntervalSince1970
        date *= 1000000
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM d"
        let hourFormat = NSDateFormatter()
        hourFormat.dateFormat = "h:mm a"
        
        var curIndex = 0
        
        mainInstance.sortTransaction()
        
        var index = 0
        for (index = 0; index < mainInstance.active_transaction_uuids2.count; index += 1)
        {
            if(mainInstance.active_transaction_uuids2[index].paymentStatus == "completed"){
                let messageString = mainInstance.active_transaction_uuids2[index].lastMessage
                var count = messageString.characters.count
                tableData[1].append(messageString[messageString.startIndex..<messageString.startIndex.advancedBy(count)])
                curIndex = 1
            }
            else if(mainInstance.active_transaction_uuids2[index].paymentStatus == "proposed"){
                curIndex = 0
                tableData[0].append("RECEIPT")
            }
            else{
                let messageString = mainInstance.active_transaction_uuids2[index].lastMessage
                var count = messageString.characters.count
                if(messageString.characters.count > 30){
                    count = 30
                }
                curIndex = 0
                tableData[curIndex].append(messageString[messageString.startIndex..<messageString.startIndex.advancedBy(count)])
                //tableData[0].append("test")
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
            detailData[curIndex].append(dateString)
        }
        
        sampleList[0] = mainInstance.active_transaction_uuids2.count - completed
        sampleList[1] = completed
        
        print(completed)
        print(mainInstance.active_transaction_uuids2.count)
        
        self.tableView.reloadData()
    }
    
    func gotoSettings(sender:UIButton!){
        self.performSegueWithIdentifier("goToSettings23", sender: self);
        
    }
    
    func btnTouched(sender:UIButton!){
        self.performSegueWithIdentifier("makeOrder", sender: self);
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = false
        mainInstance.comingfrom = "orders"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ordersView.loadList(_:)),name:"load", object: nil)
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
        if(mainInstance.active_transaction_uuids2.count == 0){
           return 0
        }
        else{
            return 2
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count //tableData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var offset = 0
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        print("Length",sampleList[0])
        print(tableData.count)
        if(indexPath.section == 1){
            offset = sampleList[0]
        }
        cell.textLabel?.text = tableData[indexPath.section][indexPath.row]
        cell.detailTextLabel?.text = detailData[indexPath.section][indexPath.row]
        return cell
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoOrder" {
            let path = tableView.indexPathForSelectedRow
            let destination = segue.destinationViewController as! orderMessenger
            destination.data = UUIDs[(path?.row)! + (tableData[0].count * (path?.section)!)]
        }
        else if(segue.identifier == "gotoCompleted"){
            let path = tableView.indexPathForSelectedRow
            let destination = segue.destinationViewController as! orderMessenger
            destination.data = UUIDs[(path?.row)! + (tableData[0].count * (path?.section)!)]
        }
        else if(segue.identifier == "goToSettings23"){
            let secondVC: profile = segue.destinationViewController as! profile
            secondVC.hidesBottomBarWhenPushed = true
        }
        else if(segue.identifier == "showTutorial"){
            let secondVC: showTutorial = segue.destinationViewController as! showTutorial
            secondVC.hidesBottomBarWhenPushed = true
        }
        else if(segue.identifier == "makeOrder"){
            let secondVC: CustomOrder = segue.destinationViewController as! CustomOrder
            secondVC.hidesBottomBarWhenPushed = true
            secondVC.labelText = "Please send us a text message with your request or desired item"
            secondVC.fromOrders = true
        }
    }
    
}