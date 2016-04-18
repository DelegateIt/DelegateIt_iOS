//
//  payment.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 12/23/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit
import Google

class payment: UIViewController {

    @IBOutlet weak var paymentWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading payment")
        self.title = "Confirm Payment"
        
        //print(mainInstance.currentTransaction.paymentURL)
        
        let url = NSURL (string: mainInstance.currentTransaction.paymentURL);
        let requestObj = NSURLRequest(URL: url!);
        paymentWebView.loadRequest(requestObj);
    }
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Payment Page")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        
        mainInstance.autoDismiss = true
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

    