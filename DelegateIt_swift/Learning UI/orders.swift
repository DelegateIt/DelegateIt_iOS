//
//  orders.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/10/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit

class Orders: UIViewController,UITableViewDataSource {
    let userOrders = [
        ("Order1","Tuesday"),
        ("Order2","Tuesday"),
        ("Order3","Tuesday"),
        ("Order4","Tuesday"),
        ("Order5","Tuesday"),
        ("Order6","Tuesday"),
        ("Order7","Tuesday"),
        ("Order8","Tuesday"),
        ("Order9","Wed") ]
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userOrders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let (orderText,orderTime) = userOrders[indexPath.row]
        
        //var image : UIImage = UIImage(named: "drycleaning.jpg")!
        //cell.imageView!.image = image
        
        cell.textLabel?.text = orderText
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       // let path = self.tableView.indexPathForSelectedRow()!
        //segue.destinationViewController.detail = self.detailForIndexPath(path)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("ashdjkfl")
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("SendDataSegue", sender: self)
        }
        
    }

}

