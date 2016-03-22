 //
//  quickorder.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/10/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import UIKit
import Google

class quickorder: UIViewController {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    var descriptions:[String] = ["I would like to book a paddleboarding trip on Lake Austin","I want Tiff's Treats cookies delivered to me","I would like to book a double decker tour of Austin","I want a large pizza from Austin's Pizza","I would like to have my clothes dry cleaned",""]
    var extraInformation:[String] = ["Paddle board on the beautiful Lake Austin. We know the best place!","Made from scratch and right out of the oven, these cookies will be sure to delight.","Want to get out and see the town?","The sauce, fresh ingredients, and charmingly local Austin's Pizza has been making our favorite pies since 1999.","Clean and fresh clothes with pick-up and drop-off.","As your personal concierge, we accept any order. Give us a challenge, we dare you."]
    var descrionChosen = ""
    
    var buttonList:[UIButton] = []
    
    var lastPicked = -1;
    
    override func viewWillAppear(animated: Bool) {
        if(mainInstance.gotoOrders){
            tabBarController?.selectedIndex = 2
        }
        else{
            let tracker = GAI.sharedInstance().defaultTracker
            tracker.set(kGAIScreenName, value: "quickorder")
            
            let builder = GAIDictionaryBuilder.createScreenView()
            tracker.send(builder.build() as [NSObject : AnyObject])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.tabBar.hidden = false
        
        mainInstance.comingfrom = "popular"
        
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        replyBtn.setImage(UIImage(named: "profileIcon.png"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: Selector("gotoSettings:"), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
        
        
        //Make the button yellow
        let tabItem = self.tabBarController?.tabBar.items![1]
        tabItem?.image = UIImage(named: "plus.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarController?.tabBar.items![1].setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1.0)], forState: UIControlState.Normal)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let myImages = ["new_paddleboarding.png","new_cookies.png","new_toa.png","new_pizza.png","new_drycleaning","new_orderanything.png"]
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
            
            //start
            
            /*
            
            let button = UIButton(type: UIButtonType.System) as UIButton
            button.frame = CGRectMake((screenSize.width-(screenSize.width/1.2))/2, 120, screenSize.width/1.2, 100)
            button.frame.size.height = myImageView.frame.height
            button.frame.size.width = myImageView.frame.width
            button.center = myImageView.center
            //button.center.y = button.center.y - 35
            button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            button.setTitle(extraInformation[index], forState: .Normal)
            button.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size: 16.0)
            button.titleLabel?.numberOfLines = 3
            button.titleLabel?.textAlignment = NSTextAlignment.Center
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            //button.alpha = 0.4
            button.tag = index
            button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
            //button.hidden = true
            button.enabled = true
            button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            button.titleLabel?.alpha = 0
            button.isAccessibilityElement = true
    
            buttonList.append(button)
            
            myScrollView.addSubview(button) //might need to move back
 
            */
            
            //end
            
            myScrollView.addSubview(myImageView)
            
            
            
            yPosition += imageHeight + 2
            scrollViewContentSize += imageHeight
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            tapGestureRecognizer
            myImageView.userInteractionEnabled = true
            myImageView.addGestureRecognizer(tapGestureRecognizer)
            myScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize)
        }
        myScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize+10)
        
        
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position :CGPoint = touch.locationInView(view)
            print(position.x)
            print(position.y)
            
        }
    }
    
    func btnTouched(sender:UIButton!){
        if(buttonList[sender.tag].backgroundColor != UIColor.blackColor().colorWithAlphaComponent(0)){
            buttonList[sender.tag].backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
            buttonList[sender.tag].titleLabel?.alpha = 0
        }
        else{
            if(lastPicked != -1){
                buttonList[lastPicked].backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
                buttonList[lastPicked].titleLabel?.alpha = 0
            }
            buttonList[sender.tag].backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            buttonList[sender.tag].titleLabel?.alpha = 1
        }
        lastPicked = sender.tag
    }
    
    func gotoSettings(sender:UIButton!){
        print("Going to settings")
        //self.tabBarController?.hidesBottomBarWhenPushed = false
        //self.tabBarController?.tabBar.hidden = true
        self.performSegueWithIdentifier("goToSettings24", sender: self);
        
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
        //self.tabBarController?.tabBar.hidden = false
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
        else if(segue.identifier == "goToSettings24"){
            let secondVC: profile = segue.destinationViewController as! profile
            secondVC.hidesBottomBarWhenPushed = true
        }
    }

    
}

