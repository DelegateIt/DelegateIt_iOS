//
//  PopUpViewControllerSwift.swift
//  NMPopUpView
//
//  Created by Nikos Maounis on 13/9/14.
//  Copyright (c) 2014 Nikos Maounis. All rights reserved.
//

import UIKit
import QuartzCore

@objc public class PopUpViewControllerSwift : UIViewController {
    var isShowing:Bool = false
    
    @IBAction func hidePopUp(sender: AnyObject) {
        self.removeAnimate()
    }

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 8.0
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        
        self.popUpView.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        if(mainInstance.comingfrom == "basics"){
            self.view.frame.origin.y = +60
        }
        
        //self.view.frame.origin.x = -30
        
        webView.layer.cornerRadius = 8.0
        webView.clipsToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PopUpViewControllerSwift.removePopup(_:)),name:"removePOP", object: nil)
    }
    
    func removePopup(notification: NSNotification){
        self.removeAnimate()
    }
    
    public func showInView(aView: UIView!, withMessage message: String!, animated: Bool)
    {
        aView.addSubview(self.view)
        let url = NSURL (string:"https://www.godelegateit.com/how-it-works.html");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
        
        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.alpha = 1.0
    }
    
    func removeAnimate()
    {
        mainInstance.isHelpShowing = false
        self.view.alpha = 0.0;
    }
    
}
