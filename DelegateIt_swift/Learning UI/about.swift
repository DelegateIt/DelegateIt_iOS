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
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(blogName)
        self.title = blogName
        
        
        if(blogName == "WORK WITH US"){
            showWebView("https://godelegateit.com/properties/")
        }
        else {
            showWebView("http://delegateit.co/")
        }
        
    }
    
    
    func showWebView(websiteName:String){
        let url = NSURL (string:websiteName);
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
    }
}