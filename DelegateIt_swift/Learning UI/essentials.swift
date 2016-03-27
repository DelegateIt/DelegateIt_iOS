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
    var eName:[String] = ["e1","e2","e3","e4","e5","e6"]
    var nameSent:String = ""
    
    var screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var button:UIButton = UIButton()
    
    var isRemoved:Bool = true
    
    var yPosition:CGFloat = 0
    var scrollViewContentSize:CGFloat = 0
    
    @IBOutlet weak var eScrollView: UIScrollView!
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.items![1].title = "Basics"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BASICS"
        
        
        let myImages = ["e1_small.png","s2_small.png","e3_small.png","e1_small.png","s2_small.png","e3_small.png"]
        
        let replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        replyBtn.setImage(UIImage(named: "profileIcon.png"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: Selector("gotoSettings:"), forControlEvents:  UIControlEvents.TouchUpInside)
        let item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
        
        
        let imageWidth:CGFloat = screenSize.width
        
        
        
        for var index = 0; index < myImages.count; index+=1
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
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            tapGestureRecognizer
            myImageView.userInteractionEnabled = true
            myImageView.addGestureRecognizer(tapGestureRecognizer)
            eScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize)
        }
        eScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize+10)
        eScrollView.delegate = self
        eScrollView.bounces = false
        
        button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(20, screenSize.height-140+5, screenSize.width-40, 60)
        button.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        button.setTitle("ORDER ANYTHING", forState: .Normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 24.0)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: "customOrder:", forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
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
        self.performSegueWithIdentifier("eForm", sender: nil)
    }
    
    func scrollViewDidScroll(eScrollView: UIScrollView){
        //print(eScrollView.contentOffset.y)
        if(eScrollView.contentOffset.y > 120){
            eScrollView.contentSize = CGSize(width:100, height: scrollViewContentSize + 70)
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.button.frame = CGRectMake(0, self.screenSize.height - 110, self.screenSize.width, 60)
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
            let secondVC: essentialsForm = segue.destinationViewController as! essentialsForm
            secondVC.hidesBottomBarWhenPushed = true
            secondVC.orderName = nameSent
        }
        else if(segue.identifier == "goToSettings24"){
            let secondVC: profile = segue.destinationViewController as! profile
            secondVC.hidesBottomBarWhenPushed = true
        }
        else if segue.identifier == "showText" {
            let secondVC: CustomOrder = segue.destinationViewController as! CustomOrder
            secondVC.orderText = ""
        }

    }
    

}