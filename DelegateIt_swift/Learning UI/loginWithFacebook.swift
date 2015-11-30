//
//  loginWithFacebook.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/27/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation


class loginWithFacebook: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var bg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() != nil){
            dispatch_async(dispatch_get_main_queue(), {self.performSegueWithIdentifier("loginSegue2", sender: self) })
        }else{
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getData(fbID:String,fbToken:String) {
        RestApiManager.sharedInstance.loginUser(fbID,fbToken: fbToken)
        //RestApiManager.sharedInstance.getUser()
        
        print("printing")
        print("Getting user")
    }
    
    
    // Facebook Delegate Methods
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Get user info and go to main app
                self.returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,first_name,last_name,email,picture", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("first_name") as! NSString
                let fbID : NSString = result.valueForKey("id") as! NSString
                print(fbID)
                print(result)
                print("User Name is: \(userName)")
                print("FB token: \(FBSDKAccessToken.currentAccessToken().tokenString)")
                if(result.valueForKey("email") != nil) {
                    let userEmail : NSString = result.valueForKey("email") as! NSString
                    print("User Email is: \(userEmail)")
                }
                
                let fbToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                self.getData(fbID as String,fbToken: fbToken)
                
                
                
            }
        })
    }
    
}