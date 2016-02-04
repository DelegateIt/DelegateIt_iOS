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
    var descriptions:[String] = ["1","2","3","4","5","6"] //change
    var descrionChosen = ""
    
    var timer: NSTimer = NSTimer()
    
    
    
    override func viewDidLoad() {
        //print(yourVariable)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        mainInstance.printHello()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let myImages = ["reservation.jpg","tripplanning.jpg","drycleaning.jpg","quick1.png","quick2.png","quick3.png"]
        
        let imageWidth:CGFloat = screenSize.width
        var yPosition:CGFloat = 0
        var scrollViewContentSize:CGFloat = 0;
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "loadbadge", userInfo: nil, repeats: true)
        
        
        for var index = 0; index < myImages.count; index++
        {
            
            let myImage:UIImage = UIImage(named: myImages[index])!
            let myImageView:UIImageView = UIImageView()
            
            myImageView.image = myImage
            
            //print(screenSize.width)
            
            //print(myImage.size); //print width and height
            
            let imageHeight2:CGFloat = myImage.size.height
            let imageWidth2:CGFloat = myImage.size.width
            
            let imageHeight:CGFloat = (imageHeight2/imageWidth2) * imageWidth
            
            
            myImageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            myImageView.frame.size.width = imageWidth
            myImageView.frame.size.height = imageHeight
            //myImageView.frame.origin.x = 10
            myImageView.center = self.view.center
            myImageView.frame.origin.y = yPosition
            myImageView.tag = index
            
            myScrollView.addSubview(myImageView)
            
            
            yPosition += imageHeight
            scrollViewContentSize += imageHeight
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            tapGestureRecognizer
            myImageView.userInteractionEnabled = true
            myImageView.addGestureRecognizer(tapGestureRecognizer)
            
            myScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize)
            
    
        }

        
        
        
        var replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        replyBtn.setImage(UIImage(named: "profileIcon.png"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: Selector("gotoSettings:"), forControlEvents:  UIControlEvents.TouchUpInside)
        var item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.rightBarButtonItem = item
        
        //
        
        
        //let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewControllerIdentifier") as? messenger
        //self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
        
        
    }
    
    func gotoSettings(sender:UIButton!){
        print("Going to Settings")
        self.performSegueWithIdentifier("goToSettings22", sender: self);
        
    }
    
    func loadbadge() {
        if(mainInstance.first_name != ""){
            let tabItem = self.tabBarController?.tabBar.items![2]
            var myString = String(mainInstance.activeCount)
            tabItem?.badgeValue = myString
            timer.invalidate()
        }
    }
    
    func imageTapped(img: AnyObject?)    {
        let iv : UIView! = img!.view
        //print(iv.tag)
        descrionChosen = descriptions[iv.tag]
        self.performSegueWithIdentifier("showText", sender: nil)
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

