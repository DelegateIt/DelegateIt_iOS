//
//  TableViewCell.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/10/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit;

class TableViewCell: UIViewController {
    
    @IBOutlet weak var titleLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
