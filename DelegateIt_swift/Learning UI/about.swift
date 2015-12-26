//
//  about.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 12/22/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit

class about: UIViewController {
    
    var blogName:String?
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("----")
        print(blogName)
        self.title = blogName
        print("ABOUTasdf")
    }
}