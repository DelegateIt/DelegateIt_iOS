//
//  loginWithFacebook.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/27/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import SwiftyJSON


class loginWithFacebook: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var bg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View loaded")
        
        //dispatch_async(dispatch_get_main_queue(), {self.performSegueWithIdentifier("loginSegue2", sender: self) })
        
        if(FBSDKAccessToken.currentAccessToken() != nil){
            self.returnUserData()
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func getData(fbID:String,fbToken:String,first_name:String,last_name:String,email:String) {
        RestApiManager.sharedInstance.loginUser(fbID,fbToken:fbToken,first_name:first_name,last_name:last_name,email:email)
        
        //dispatch_async(dispatch_get_main_queue(), {self.performSegueWithIdentifier("loginSegue2", sender: self) })
        //self.performSegueWithIdentifier("loginSegue2", sender: self)
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
                print("-----------")
                print("fetched user: \(result)")
                let first_name : String = result.valueForKey("first_name") as! String
                let last_name : String = result.valueForKey("last_name") as! String
                let fbID : String = result.valueForKey("id") as! String
                var email = ""
                if(result.valueForKey("email") != nil) {
                    email = result.valueForKey("email") as! String
                    print("User Email is: \(email)")
                }
                
                let fbToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                //Test mode
                //fbID = "130017354031600"
                //fbToken = "CAANG1yne7NcBAILZBiFlfkwa7DoxJm5mc6yRQdqyWFyzHN6jRn5KtJKEHTZAZADmFZAsBnankuKFYpV0OBEZBym0QTXYNBEZA6rkQIQZAJuW3MJwnm9DDmqsrvOHnsI2I6t7wQSLXnoy4xrhehbeuMVkhsPqZBL2kZCSiviRva63NxKplge8f3GXGaIeeK0JUCQ8wDvSakBvhuSrGJg0IYMNB"
                
                
                self.getData(fbID as String,fbToken: fbToken,first_name:first_name,last_name:last_name,email:email)
            }
        })
    }
    
}