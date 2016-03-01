 //
//  quickorder.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/10/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit

class quickorder: UIViewController {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    var descriptions:[String] = ["I would like to book a paddleboarding trip on Lake Austin","I want Tiff's Treats coookies delivered to me","I would like to book a double decker tour of Austin","I want a large pizza from Austin's Pizza"]
    var descrionChosen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let myImages = ["order4.png","order2.png","quick3.png","order1.png"]
        let imageWidth:CGFloat = screenSize.width
        var yPosition:CGFloat = 0
        var scrollViewContentSize:CGFloat = 0;

        for var index = 0; index < myImages.count; index++
        {
            let myImage:UIImage = UIImage(named: myImages[index])!
            let myImageView:UIImageView = UIImageView()
            
            myImageView.image = myImage
            
            let imageHeight2:CGFloat = myImage.size.height
            let imageWidth2:CGFloat = myImage.size.width
            let imageHeight:CGFloat = (imageHeight2/imageWidth2) * imageWidth
            
            
            myImageView.contentMode = UIViewContentMode.ScaleAspectFit
            myImageView.frame.size.width = imageWidth
            myImageView.frame.size.height = imageHeight
            myImageView.center = self.view.center
            myImageView.frame.origin.y = yPosition
            myImageView.tag = index
            
            myScrollView.addSubview(myImageView)
            
            yPosition += imageHeight + 2
            scrollViewContentSize += imageHeight
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            tapGestureRecognizer
            myImageView.userInteractionEnabled = true
            myImageView.addGestureRecognizer(tapGestureRecognizer)
            myScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize)
        }
        
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        replyBtn.setImage(UIImage(named: "profileIcon.png"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: Selector("gotoSettings:"), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
        
        RestApiManager.sharedInstance.downloadProfilePic()
        
        /*
        
        let helpBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        helpBtn.setImage(UIImage(named: "help.png"), forState: UIControlState.Normal)
        helpBtn.addTarget(self, action: Selector("gotoSettings:"), forControlEvents:  UIControlEvents.TouchUpInside)
        let item2 = UIBarButtonItem(customView: helpBtn)
        self.navigationItem.leftBarButtonItem = item2
 
        */
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBadge:",name:"loadbadge", object: nil)
        
        loadBadge()
    }
    
    func gotoSettings(sender:UIButton!){
        self.performSegueWithIdentifier("goToSettings22", sender: self);
        
    }
    
    func updateBadge(notification: NSNotification){
        loadBadge()
    }
    
    func loadBadge(){
        if(mainInstance.active_transaction_uuids2.count != 0){
            var badgeCount = 0
            for(var index = 0; index < mainInstance.active_transaction_uuids2.count; index++){
                if(mainInstance.active_transaction_uuids2[index].paymentStatus != "completed"){
                    badgeCount++
                }
            }
            if(badgeCount != 0){
                let tabItem = self.tabBarController?.tabBar.items![2]
                let myString = String(badgeCount)
                tabItem?.badgeValue = myString
            }
        }
    }
    
    func imageTapped(img: AnyObject?)    {
        let iv : UIView! = img!.view
        descrionChosen = descriptions[iv.tag]
        self.performSegueWithIdentifier("showText", sender: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    func buttonPressed(sender: UIButton!) {
        //print("Moving scene")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showText" {
            let secondVC: CustomOrder = segue.destinationViewController as! CustomOrder
            secondVC.orderText = descrionChosen
        }
    }
    
}

