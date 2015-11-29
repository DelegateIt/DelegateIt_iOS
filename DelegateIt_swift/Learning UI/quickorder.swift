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
        
        
        for var index = 0; index < myImages.count; index++
        {
            
            let myImage:UIImage = UIImage(named: myImages[index])!
            let myImageView:UIImageView = UIImageView()
            
            myImageView.image = myImage
            
            print(screenSize.width)
            
            print(myImage.size); //print width and height
            
            let imageHeight2:CGFloat = myImage.size.height
            let imageWidth2:CGFloat = myImage.size.width
            
            let imageHeight:CGFloat = (imageHeight2/imageWidth2) * imageWidth
            
            
            myImageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            myImageView.frame.size.width = imageWidth
            myImageView.frame.size.height = imageHeight
            //myImageView.frame.origin.x = 10
            myImageView.center = self.view.center
            myImageView.frame.origin.y = yPosition
            
            myScrollView.addSubview(myImageView)
            
            
            yPosition += imageHeight
            scrollViewContentSize += imageHeight
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            myImageView.userInteractionEnabled = true
            myImageView.addGestureRecognizer(tapGestureRecognizer)
            
            myScrollView.contentSize = CGSize(width:imageWidth, height: scrollViewContentSize)
        }
        
        //
        
        
        //let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewControllerIdentifier") as? messenger
        //self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
        
    }
    
    func imageTapped(img: AnyObject)
    {
        // Your action
        print("PRESSED")
        self.performSegueWithIdentifier("showText", sender: nil)
    }
    
    
    func buttonPressed(sender: UIButton!) {
        print("PRESSED")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCounterSegue" {
            if let destinationVC = segue.destinationViewController as? CustomOrder{
                //destinationVC.numberToDisplay = 2
            }
        }
    }
    
}

