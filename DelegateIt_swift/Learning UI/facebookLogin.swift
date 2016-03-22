//
//  loginWithFacebook.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/27/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftSpinner
import Google
import UIKit

class facebookLogin: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var bg: UIImageView!
    var imageView = UIImageView()
    var loginView : FBSDKLoginButton = FBSDKLoginButton()
    var loggedIn = 0
    var reconnectTimer = NSTimer()
    var moveLogo = true
    var spinning = false
    
    
    var first_name:String = ""
    var last_name:String = ""
    var fbID:String = ""
    var email = ""
    var fbToken:String = ""
    
    
    //load if the user is not logged in
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        config().getConfig()
        
        loggedIn = 0
        
        if(FBSDKAccessToken.currentAccessToken() != nil){
            self.returnUserData()
        }else{
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            if(moveLogo){
                imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth/2, (screenWidth/2)/1.106)) // set as you want
                imageView.center = self.view.center
                let image = UIImage(named: "logo.png")
                imageView.image = image
                self.view.addSubview(imageView)
                self.moveLogoView(CGPointMake(screenSize.width/2, screenHeight * 0.3))
            }
        }
        moveLogo = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginUser:",name:"readyToLogin", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Login")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func initializeNotificationServices() -> Void {
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // This is an asynchronous method to retrieve a Device Token
        // Callbacks are in AppDelegate.swift
        // Success = didRegisterForRemoteNotificationsWithDeviceToken
        // Fail = didFailToRegisterForRemoteNotificationsWithError
        UIApplication.sharedApplication().registerForRemoteNotifications()
        self.loginUser()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func moveLogoView(point: CGPoint){
        UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.imageView.center = point
            }) {(completed) -> Void in
                print("The box has moved")
                self.view.addSubview(self.loginView)
                self.loginView.center = self.view.center
           self.loginView.readPermissions = ["public_profile", "email"]
           self.loginView.delegate = self
        }
    }
    
    // Facebook Delegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil){
            let alertController = UIAlertController(title: "Login Error", message:"Please login with Facebook to continue", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if result.isCancelled {
            let alertController = UIAlertController(title: "Login Cancelled", message:"Please login with Facebook to continue", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //Logout Function
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func internetChecker(){
        if(!RestApiManager.sharedInstance.isConnectedToNetwork()){
            SwiftSpinner.show("No connection, trying to reconnect...")
        }
        else{
            SwiftSpinner.show("Reconnecting")//Reconnecting
        }
    }
    
    
    
    //Return data collected from Facebook
    func returnUserData(){
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,first_name,last_name,email,picture", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            //Error With logging into Facebook
            if ((error) != nil){
                if(!self.spinning){
                    let alertController = UIAlertController(title: "Login Error", message:"Please login with Facebook to continue", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let Dismiss = UIAlertAction(title: "Dismiss", style: .Default) { (action) in
                        self.internetChecker()
                        self.spinning = true
                        self.reconnectTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("returnUserData"), userInfo: nil, repeats: true)
                    }
                    
                    alertController.addAction(Dismiss)
                    let tryAgain = UIAlertAction(title: "Try Again", style: .Default) { (action) in
                        self.dismissViewControllerAnimated(false, completion: nil)
                        self.returnUserData()
                    }
                    
                    alertController.addAction(tryAgain)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else{
                    self.internetChecker()
                }
                
            }
            else
            {
                self.first_name = result.valueForKey("first_name") as! String
                self.last_name = result.valueForKey("last_name") as! String
                self.fbID =  result.valueForKey("id") as! String
                
                if(result.valueForKey("email") != nil) {
                    self.email = result.valueForKey("email") as! String
                    print("User Email is: \(self.email)")
                }
                
                self.fbToken = FBSDKAccessToken.currentAccessToken().tokenString
                SwiftSpinner.show("Connecting...")
                mainInstance.fbID = self.fbID
                
                print("PUSH")
                //print(UIApplication.sharedApplication().isRegisteredForRemoteNotifications())
                
                self.initializeNotificationServices()
                
                //
            }
        })
    }
    
    func loginUser() {
        RestApiManager.sharedInstance.loginUser(fbID,fbToken:fbToken,first_name:first_name,last_name:last_name,email:email){ (response) in
            if(response == 1){
                self.loginView.hidden = true
                SwiftSpinner.hide()
                self.reconnectTimer.invalidate()
                if(self.loggedIn == 0){
                    self.loggedIn = 1
                    self.tabBarController?.selectedIndex = 2
                    dispatch_async(dispatch_get_main_queue(), {self.performSegueWithIdentifier("login", sender: self) })
                }
                else{
                    print("Double call")
                }
                
                
            }else if(response == -1){
                dispatch_async(dispatch_get_main_queue(), {
                    SwiftSpinner.show("Can't connect to server!")
                    if(!RestApiManager.sharedInstance.isConnectedToNetwork()){
                        notificationH.printHello("No Internet Connection")
                    }
                    NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("loginUser"), userInfo: nil, repeats: false)
                })
            }
        }
    }
}