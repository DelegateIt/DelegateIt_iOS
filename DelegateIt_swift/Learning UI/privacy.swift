//
//  privacy.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 4/30/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit


class privacy: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewWillAppear(animated: Bool) {
        //title = "Tutorial"
        //self.navigationController?.navigationBarHidden = true
        //UIApplication.sharedApplication().statusBarHidden = true
        let url = NSURL (string:"https://www.godelegateit.com/privacy-policy.html");
        let requestObj = NSURLRequest(URL: url!);
        
        
        webView.loadRequest(requestObj);
        webView.backgroundColor = UIColor.whiteColor()
        
        //webView.layer.cornerRadius = 8.0
        webView.clipsToBounds = true
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(showTutorial.tap(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.enabled = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake((screenSize.width-webView.frame.width)/2, webView.frame.origin.y + (webView.frame.height), webView.frame.width, 60)
        button.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        button.setTitle("Close", forState: .Normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(showTutorial.btnTouched(_:)), forControlEvents:.TouchUpInside)
        //button.layer.cornerRadius = 8.0
        self.view.addSubview(button)

    }
    
    func tap(recognizer: UITapGestureRecognizer){
        self.performSegueWithIdentifier("goHome", sender: self);
    }
    
    func btnTouched(sender:UIButton!){
        self.performSegueWithIdentifier("goHome", sender: self);
    }
}