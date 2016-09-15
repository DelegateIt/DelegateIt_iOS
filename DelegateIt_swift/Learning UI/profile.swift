//
//  profile.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/10/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//


import Foundation
import FBSDKLoginKit
import Google
import Social

class profile: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    
    let textCellIdentifier = "TextCell"
    let blogSegueIdentifier = "ShowBlogSegue"
    let swiftBlogs = ["EDIT PROFILE","WEBSITE","FEEDBACK"]
    var choosenRow = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds

        let button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, screenSize.height-60, screenSize.width, 60)
        button.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        button.setTitle("LOGOUT", forState: .Normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(profile.btnTouched(_:)), forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
        print(button.frame.origin.x)
        
        if(mainInstance.comingfrom == "popular"){
            print("from popular")
            button.frame.origin.y = button.frame.origin.y - (button.frame.height*1.02)
        }
        
        
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.blackColor().CGColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        self.imageView.image = mainInstance.profilePic
        
        tableView.alwaysBounceVertical = false;
        self.tableView.tableFooterView = UIView()
        
        tableView.frame.origin.x = screenSize.width/2
        tableView.frame.origin.y = screenSize.height/2
        
        
        let shareBtn : UIBarButtonItem = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(profile.shareBtn(_:)))

        self.navigationItem.rightBarButtonItem = shareBtn
    }
    
    func shareBtn(action:UIBarButtonItem){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        userName.text = mainInstance.first_name + " " + mainInstance.last_name
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "profile")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    
   
    
    func btnTouched(sender:UIButton!){
        mainInstance.emptyData()
        socketManager.stopSockets()
        FBSDKLoginManager().logOut()
        self.performSegueWithIdentifier("logout", sender: self);
    }
    
    func goHome(sender:UIButton!){
        print("Going Home")
        self.performSegueWithIdentifier("goHome22", sender: self);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "sample2"){
            let destination = segue.destinationViewController as! about
            destination.blogName = choosenRow
        }
    }
    
    // MARK: - UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = swiftBlogs[row]
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        choosenRow = swiftBlogs[row]
        
        if(choosenRow == "WEBSITE" || choosenRow == "FEEDBACK" || choosenRow == "HOW IT WORKS?" || choosenRow == "VERSION") {
            self.performSegueWithIdentifier("sample2", sender: self);
        }
        else {
            self.performSegueWithIdentifier("ShowBlogSegue", sender: self);
        }
    }
    
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

    func logout() {
        FBSDKLoginManager().logOut()
    }
    
    
    
}
