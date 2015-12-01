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
    
    @IBOutlet weak var lastName_input: UITextField!
    @IBOutlet weak var firstName_input: UITextField!
    @IBOutlet weak var phoneNumber_input: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func LogoutUser(sender: AnyObject) {
        FBSDKLoginManager().logOut()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName_input.text = mainInstance.first_name
        lastName_input.text = mainInstance.last_name
        phoneNumber_input.text = mainInstance.phone_number
        emailInput.text = mainInstance.email
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
