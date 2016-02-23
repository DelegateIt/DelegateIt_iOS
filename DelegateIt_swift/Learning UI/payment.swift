//
//  payment.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 12/23/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit;

class payment: UIViewController {

    @IBOutlet weak var paymentWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading payment")
        self.title = "CONFIRM PAYMENT"
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = NSURL (string: mainInstance.currentTransaction.paymentURL);
        let requestObj = NSURLRequest(URL: url!);
        paymentWebView.loadRequest(requestObj);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sayHello(sender: UIBarButtonItem) {
        //backToOrder
        self.performSegueWithIdentifier("CompleteOrder", sender: self);
    }
    
}

    