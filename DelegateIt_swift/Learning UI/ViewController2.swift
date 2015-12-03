//
//  ViewController.swift
//  TableView
//
//  Created by Jared Davidson on 1/16/15.
//  Copyright (c) 2015 Archetapp. All rights reserved.
//

import Foundation
import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet var TextView: UITextView!
    
    var FirstString = String()
    
    override func viewDidLoad() {
        
        
        TextView.text = FirstString
    }
}