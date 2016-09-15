//
//  BlogViewController.swift
//  Table Segue
//
//  Created by Ben Wernsman on 12/22/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit

class BlogViewController: UIViewController {
    

    @IBOutlet weak var blogNameLabel: UILabel!
    
    var blogName = NSString()
    
    override func viewWillAppear(animated: Bool) {
        blogNameLabel.text = blogName as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
