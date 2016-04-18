//
//  essentials.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 3/24/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation

import UIKit

class essentials: UIViewController, UIScrollViewDelegate {
    
    var buttonList:[UIButton] = []
    var eName:[String] = ["Food Delivery","Daily Essentials","Advice and Recommendations ","Reservations","Grocery Delivery","Laundry and Dry Cleaning"]
    
    var dName:[String] = [
    "1. What type of food would you like?\n2. Is there a specific restauraunt you would like it from?\n3. Where and when would you like it delivered?",
    "Send us a request with the items you need delivered. (toothbrush, shampoo, etc.)",
    "Ask us about good resaurants or things to do!",
    "1. What restuarant or type of restaurant would you like a reservation for?\n2. What day and time do you want your reservation for?\n3. How many people will be going?",
    "1. What groceries do you want?\n2. Do you have any specific preferences like organic or non-GMO?\n3. When would you like yourgroceries delivered?",
    "1. About how many loads of laundry do you have?\n2. How many items do you need dry cleaned?\n3. Where and what time would you like your clothes picked up and dropped off?"]
    
    var currentName:String = ""
    
    var nameSent:String = ""
    
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var button:UIButton = UIButton()
    
    var isRemoved:Bool = true
    
    var yPosition:CGFloat = 0
    var scrollViewContentSize:CGFloat = 0
    
    var buttonBG = UIButton()
    
    var popViewController : PopUpViewControllerSwift!
    
    var sOffset:CGFloat = 0
    
    @IBOutlet weak var eScrollView: UIScrollView!
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.items![1].title = "Basics"
        
        
        
        if(screenSize.height == 736){
            sOffset = 7 //iphone 6+
        }
        else if(screenSize.height == 568){
            sOffset = -10 //Iphone 5
        }
        else if(screenSize.height == 480){
            sOffset = 78 //Iphone 4s
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        mainInstance.comingfrom = "basics"
        mainInstance.autoDismiss = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Basics"
        
        //self.view.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        
        
        let helpBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        helpBtn.setImage(UIImage(named: "help.png"), forState: UIControlState.Normal)
        helpBtn.addTarget(self, action: Selector("gotoTutorial:"), forControlEvents:  UIControlEvents.TouchUpInside)
        let item2 = UIBarButtonItem(customView: helpBtn)
        self.navigationItem.leftBarButtonItem = item2
        
        
        let myImages = ["b1.png","b2.png","b3.png","b4.png","b5.png","b6.png"]
        
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        replyBtn.setImage(UIImage(named: "profileIcon.png"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: #selector(essentials.gotoSettings(_:)), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
        
        
        let imageWidth:CGFloat = screenSize.width
        
        buttonBG = UIButton(type: UIButtonType.System) as UIButton
        buttonBG.frame = CGRectMake(20, screenSize.height-140+5, screenSize.width-40, 60)
        buttonBG.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        buttonBG.alpha = 0
        
        self.view.addSubview(buttonBG)
        
        
        for index in 0 ..< myImages.count
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

            eScrollView.addSubview(myImageView)
            yPosition += imageHeight + 2
            scrollViewContentSize += imageHeight
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(essentials.imageTapped(_:)))
            tapGestureRecognizer
            myImageView.userInteractionEnabled = true
            myImageView.addGestureRecognizer(tapGestureRecognizer)
            eScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize)
        }
        eScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize+10)
        eScrollView.delegate = self
        
        //eScrollView.bounces = false
        
        buttonBG.sendSubviewToBack(self.view)
        
        eScrollView.bringSubviewToFront(self.view)
        
        
        
        button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(20, screenSize.height-140+5, screenSize.width-40, 60)
        button.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        button.setTitle("ORDER ANYTHING", forState: .Normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 24.0)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(essentials.customOrder(_:)), forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
    }
    
    
    func gotoTutorial(sender:UIButton!){
        print("Going to settings")
        //self.tabBarController?.hidesBottomBarWhenPushed = false
        //self.tabBarController?.tabBar.hidden = true
        self.performSegueWithIdentifier("showTutorial", sender: self);
        
    }
    
    func gotoSettings(sender:UIButton!){
        self.performSegueWithIdentifier("goToSettings24", sender: self);
    }
    
    func customOrder(sender:UIButton!){
        self.performSegueWithIdentifier("showText", sender: self)
    }
    
    func imageTapped(img: AnyObject?)    {
        let iv : UIView! = img!.view
        nameSent = eName[iv.tag]
        currentName = dName[iv.tag]
        self.performSegueWithIdentifier("eForm", sender: nil)
    }
    
    func scrollViewDidScroll(eScrollView: UIScrollView){
        print(eScrollView.contentOffset.y)
        if(eScrollView.contentOffset.y > 190 + sOffset){
            buttonBG.alpha = 1
            buttonBG.frame = CGRectMake(0, screenSize.height - eScrollView.contentOffset.y+82 + sOffset, screenSize.width, eScrollView.contentOffset.y-100)
        }
        else{
            buttonBG.alpha = 0
        }
        if(eScrollView.contentOffset.y > 120 + sOffset){
            eScrollView.contentSize = CGSize(width:100, height: scrollViewContentSize + 70)
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.button.frame = CGRectMake(0, self.screenSize.height - 107, self.screenSize.width, 60)
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
                    self.button.frame = CGRectMake(20, self.screenSize.height-140+5, self.screenSize.width-40, 60)
                    self.button.frame.origin.x = 20
                    self.button.frame.origin.y = self.screenSize.height-140+5
                }) {(completed) -> Void in
                    //done
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "eForm" {
            //let secondVC: essentialsForm = segue.destinationViewController as! essentialsForm
            //secondVC.hidesBottomBarWhenPushed = true
            //secondVC.orderName = nameSent
            
            let secondVC: CustomOrder = segue.destinationViewController as! CustomOrder
            secondVC.basicName = nameSent
            secondVC.orderText = ""
            secondVC.labelText = currentName
            secondVC.fromBasic = true
        }
        else if(segue.identifier == "goToSettings24"){
            let secondVC: profile = segue.destinationViewController as! profile
            secondVC.hidesBottomBarWhenPushed = true
        }
        else if segue.identifier == "showText" {
            let secondVC: CustomOrder = segue.destinationViewController as! CustomOrder
            secondVC.orderAnything = true
            secondVC.orderText = ""
        }
        else if(segue.identifier == "showTutorial"){
            let secondVC: showTutorial = segue.destinationViewController as! showTutorial
            secondVC.hidesBottomBarWhenPushed = true
        }

    }
    

}