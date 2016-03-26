//
//  essentials.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 3/24/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation

import UIKit

class essentials: UIViewController {
    
    var buttonList:[UIButton] = []
    var eName:[String] = ["e1","e2","e3"]
    var nameSent:String = ""
    
    @IBOutlet weak var eScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ESSENTIALS"
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let myImages = ["e1.png","e2.png","e3.png"]
        
        
        let imageWidth:CGFloat = screenSize.width
        var yPosition:CGFloat = 0
        var scrollViewContentSize:CGFloat = 0;
        
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
        //eScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize+10)
    }
    
    func imageTapped(img: AnyObject?)    {
        let iv : UIView! = img!.view
        nameSent = eName[iv.tag]
        self.performSegueWithIdentifier("eForm", sender: nil)
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
    }
    

}