//
//  profile.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/10/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//


import Foundation
import FBSDKLoginKit

class profile: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    
    let textCellIdentifier = "TextCell"
    let blogSegueIdentifier = "ShowBlogSegue"
    let swiftBlogs = ["EDIT PROFILE","ABOUT US", "HOW IT WORKS?","WORK WITH US"]
    var choosenRow = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PROFILE"
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tabBarController?.tabBar.hidden = true
        let screenSize: CGRect = UIScreen.mainScreen().bounds

        let button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, screenSize.height-60, screenSize.width, 60)
        button.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        button.setTitle("LOGOUT", forState: .Normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
        if let checkedUrl = NSURL(string: "https://graph.facebook.com/" + mainInstance.fbID + "/picture?type=large") {
            imageView.contentMode = .ScaleAspectFill
            imageView.layer.borderWidth = 2
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.blackColor().CGColor
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.clipsToBounds = true
            downloadImage(checkedUrl)
        }
        
        tableView.alwaysBounceVertical = false;
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        userName.text = mainInstance.first_name + " " + mainInstance.last_name
    }
    
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func btnTouched(sender:UIButton!){
        mainInstance.emptyData()
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
        
        if(choosenRow == "ABOUT US" || choosenRow == "WORK WITH US" || choosenRow == "HOW IT WORKS?" || choosenRow == "VERSION") {
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
