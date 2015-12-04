//
//  SecondTableView.swift
//  TableView
//
//  Created by Jared Davidson on 1/16/15.
//  Copyright (c) 2015 Archetapp. All rights reserved.
//

import Foundation
import UIKit


class SecondTableViewController: UITableViewController {
    
    var SecondArray = [String]()
    var SecondAnswerArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCellWithIdentifier("SecondCell", forIndexPath: indexPath) as UITableViewCell
        
        
        Cell.textLabel?.text = "Hello"
        
        
        return Cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPath : NSIndexPath = (self.tableView?.indexPathForSelectedRow)!
        
        let DestViewController = segue.destinationViewController as! ViewController2
        
        DestViewController.FirstString = SecondAnswerArray[indexPath.row]
        
        
        
    }
}