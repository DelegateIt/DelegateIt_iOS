//
//  about.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 12/22/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit
import Google

class about: UIViewController {
    
    var blogName:String?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Webpage View")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(blogName)
        self.title = blogName
        if(blogName == "WEBSITE"){
            showWebView("http://delegateit.co/")
        }
        else if(blogName == "FEEDBACK"){
            showWebView("http://goo.gl/forms/4w9t1K2aU9")
            //showWebView("https://www.godelegateit.com/feedback.html")
        }
        
    }
    
    
    func showWebView(websiteName:String){
        let url = NSURL (string:websiteName);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
    }
}