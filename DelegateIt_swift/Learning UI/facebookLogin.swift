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


class facebookLogin: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var bg: UIImageView!
    
    
    //load if the user is not logged in
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(FBSDKAccessToken.currentAccessToken() != nil){
            self.returnUserData()
        }else{
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email"]
            loginView.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        else {
            if result.grantedPermissions.contains("email"){
                self.returnUserData()
            }
        }
    }
    
    //Logout Function
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    //Return data collected from Facebook
    func returnUserData(){
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,first_name,last_name,email,picture", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            //Error With logging into Facebook
            if ((error) != nil){
                if(!RestApiManager.sharedInstance.isConnectedToNetwork()){
                    notificationH.printHello("No Internet Connection")
                }
                
                let alertController = UIAlertController(title: "Login Error", message:"Please login with Facebook to continue", preferredStyle: UIAlertControllerStyle.Alert)
                
                let Dismiss = UIAlertAction(title: "Dismiss", style: .Default) { (action) in
                    
                }
                
                alertController.addAction(Dismiss)
                
                let tryAgain = UIAlertAction(title: "Try Again", style: .Default) { (action) in
                    self.dismissViewControllerAnimated(false, completion: nil)
                    self.returnUserData()
                }
                
                alertController.addAction(tryAgain)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else
            {
                let first_name : String = result.valueForKey("first_name") as! String
                let last_name : String = result.valueForKey("last_name") as! String
                let fbID : String = result.valueForKey("id") as! String
                var email = ""
                if(result.valueForKey("email") != nil) {
                    email = result.valueForKey("email") as! String
                    print("User Email is: \(email)")
                }
                
                let fbToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                RestApiManager.sharedInstance.loginUser(fbID,fbToken:fbToken,first_name:first_name,last_name:last_name,email:email){ (response) in
                    if(response == 1){
                        SwiftSpinner.hide()
                        dispatch_async(dispatch_get_main_queue(), {self.performSegueWithIdentifier("login", sender: self) })
                        
                    }else if(response == -1){
                        dispatch_async(dispatch_get_main_queue(), {
                            SwiftSpinner.show("Connecting...")
                            if(!RestApiManager.sharedInstance.isConnectedToNetwork()){
                                notificationH.printHello("No Internet Connection")
                            }
                            NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("returnUserData"), userInfo: nil, repeats: false)
                            
                        })
                    }
                }
            }
        })
    }
}