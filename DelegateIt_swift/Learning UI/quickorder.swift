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
import Whisper

class quickorder: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var myScrollView: UIScrollView!
    var descriptions:[String] = ["I would like to book a paddleboarding trip on Lake Austin","I want Tiff's Treats cookies delivered to me","I would like to book a double decker tour of Austin","I want a large pizza from Austin's Pizza","I would like to visit the 512 Brewery!"]
    var extraInformation:[String] = ["Paddle board on the beautiful Lake Austin. We know the best place!","Made from scratch and right out of the oven, these cookies will be sure to delight.","Want to get out and see the town?","The sauce, fresh ingredients, and charmingly local Austin's Pizza has been making our favorite pies since 1999.","Clean and fresh clothes with pick-up and drop-off.","As your personal concierge, we accept any order. Give us a challenge, we dare you."]
    var descrionChosen = ""
    
    var buttonList:[UIButton] = []
    
    var lastPicked = -1;
    
    var button:UIButton = UIButton()
    
    var isRemoved:Bool = true
    
    var buttonBG = UIButton()
    
    var scrollViewContentSize:CGFloat = 0
    
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var sOffset:CGFloat = 0
    
    var popViewController : PopUpViewControllerSwift!
    
    override func viewWillAppear(animated: Bool) {
        if(mainInstance.comingfrom == "basics"){
            self.tabBarController?.selectedIndex = 1
        }
        else if(mainInstance.gotoOrders || mainInstance.comingfrom == "orders"){
            print("set")
            self.tabBarController?.selectedIndex = 2
        }
        else{
            let tracker = GAI.sharedInstance().defaultTracker
            tracker.set(kGAIScreenName, value: "quickorder")
            
            let builder = GAIDictionaryBuilder.createScreenView()
            tracker.send(builder.build() as [NSObject : AnyObject])
        }
        
        if(screenSize.height == 736){
            sOffset = 44 //iphone 6+
        }
        else if(screenSize.height == 568){
            sOffset = -61.5 //Iphone 5
        }
        else if(screenSize.height == 480){
            sOffset = 26.5 //Iphone 4s
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notifyManager.showBanner()
        
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        replyBtn.setImage(UIImage(named: "profileIcon.png"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: #selector(quickorder.gotoSettings(_:)), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
        
        buttonBG = UIButton(type: UIButtonType.System) as UIButton
        buttonBG.frame = CGRectMake(20, self.screenSize.height-140+5, self.screenSize.width-40, 60)
        buttonBG.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        buttonBG.alpha = 0
        
        self.view.addSubview(buttonBG)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let myImages = ["new_paddleboarding.png","new_cookies.png","new_toa.png","new_pizza.png","brewing_beer.png"]
        let imageWidth:CGFloat = screenSize.width
        var yPosition:CGFloat = 0
        scrollViewContentSize = 0
        
        for index in 0..<myImages.count{
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
            
            myScrollView.delegate = self
        }
        myScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize+10)
        
        
        button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(20, screenSize.height-200, screenSize.width-40, 60)
        button.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        button.setTitle("ORDER ANYTHING", forState: .Normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 24.0)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(quickorder.customOrder(_:)), forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
        RestApiManager.sharedInstance.downloadProfilePic()
        
        let helpBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        helpBtn.setImage(UIImage(named: "help.png"), forState: UIControlState.Normal)
        helpBtn.addTarget(self, action: #selector(quickorder.gotoTutorial(_:)), forControlEvents:  UIControlEvents.TouchUpInside)
        let item2 = UIBarButtonItem(customView: helpBtn)
        self.navigationItem.leftBarButtonItem = item2
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(quickorder.updateBadge(_:)),name:"loadbadge", object: nil)
        
        loadBadge()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position :CGPoint = touch.locationInView(view)
            print(position.x)
            print(position.y)
            
            if(mainInstance.isHelpShowing){
                NSNotificationCenter.defaultCenter().postNotificationName("removePOP", object: nil)
            }
        }
    }
    
    func customOrder(sender:UIButton!){
        self.performSegueWithIdentifier("showText", sender: self)
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
        self.performSegueWithIdentifier("goToSettings24", sender: self);
        
    }
    
    func gotoTutorial(sender:UIButton!){
        print("Going to settings")
        self.performSegueWithIdentifier("showTutorial", sender: self);
        
    }
    
    func updateBadge(notification: NSNotification){
        loadBadge()
    }
    
    func loadBadge(){
        if(mainInstance.active_transaction_uuids2.count != 0){
            var badgeCount = 0
            for index in 0..<mainInstance.active_transaction_uuids2.count{
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
        mainInstance.comingfrom = "popular"
        
        mainInstance.autoDismiss = false
    }
    
    
    func buttonPressed(sender: UIButton!) {
        //print("Moving scene")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(eScrollView: UIScrollView){
        print("-->")
        print(eScrollView.contentOffset.y)
        if(eScrollView.contentOffset.y > 600 + self.sOffset){
            buttonBG.alpha = 1
            buttonBG.frame = CGRectMake(0, screenSize.height - eScrollView.contentOffset.y+436 + self.sOffset, screenSize.width, eScrollView.contentOffset.y-500)
        }
        else{
            buttonBG.alpha = 0
        }
        if(eScrollView.contentOffset.y > 540 + self.sOffset){
            eScrollView.contentSize = CGSize(width:100, height: scrollViewContentSize + 70)
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.button.frame = CGRectMake(0, self.screenSize.height - 174, self.screenSize.width, 60)
            }) {(completed) -> Void in
                //done
            }
            isRemoved = false
        }
        else{
            button.alpha = 1
            if(!isRemoved){
                isRemoved = true
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.button.frame = CGRectMake(20, self.screenSize.height-200, self.screenSize.width-40, 60)
                    self.button.frame.origin.x = 20
                    self.button.frame.origin.y = self.screenSize.height-200
                }) {(completed) -> Void in
                    //done
                }
            }
        }
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
        else if(segue.identifier == "showTutorial"){
            let secondVC: showTutorial = segue.destinationViewController as! showTutorial
            secondVC.hidesBottomBarWhenPushed = true
        }
    }


    
}

