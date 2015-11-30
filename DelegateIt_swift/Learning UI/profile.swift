//
//  profile.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/10/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//


import Foundation
import FBSDKLoginKit

class profile: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func LogoutUser(sender: AnyObject) {
        FBSDKLoginManager().logOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

    func logout() {
        FBSDKLoginManager().logOut()
    }
    
    
    
}
