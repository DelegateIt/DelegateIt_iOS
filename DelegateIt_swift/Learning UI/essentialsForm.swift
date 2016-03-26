//
//  essentialsForm.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 3/26/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit


class essentialsForm: UIViewController {
    var orderName: String = ""
    
    override func viewWillAppear(animated: Bool) {
        print(orderName)
        title = orderName
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
}