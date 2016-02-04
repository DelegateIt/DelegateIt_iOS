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
    
    let blogSegueIdentifier = "ShowBlogSegue"   //New
    
    let swiftBlogs = ["EDIT PROFILE","ABOUT US", "HOW IT WORKS?","WORK WITH US"]
    
    var choosenRow = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PROFILE"
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tabBarController?.tabBar.hidden = true
        
        
       //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        var replyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        replyBtn.setImage(UIImage(named: "x.png"), forState: UIControlState.Normal)
        replyBtn.addTarget(self, action: Selector("goHome:"), forControlEvents:  UIControlEvents.TouchUpInside)
        var item = UIBarButtonItem(customView: replyBtn)
        self.navigationItem.leftBarButtonItem = item
        
        
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let image = UIImage(named: "yellowBG.png") as UIImage?
        let button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(0, screenSize.height-60, screenSize.width, 60)
        button.backgroundColor = UIColor(red: 255/255, green: 199/255, blue: 40/255, alpha: 1)
        button.setTitle("LOGOUT", forState: .Normal)
        button.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        self.view.addSubview(button)
        
        var settingsBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        settingsBtn.setImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
        settingsBtn.addTarget(self, action: Selector("gotoSettings:"), forControlEvents:  UIControlEvents.TouchUpInside)
        var item2 = UIBarButtonItem(customView: settingsBtn)
        self.navigationItem.rightBarButtonItem = item2
        
        tableView.alwaysBounceVertical = false;
        
        // Do any additional setup after loading the view, typically from a nib.
        print("Begin of code")
        if let checkedUrl = NSURL(string: "https://graph.facebook.com/1237026922980425/picture?type=large") {
            imageView.contentMode = .ScaleAspectFill
            imageView.layer.borderWidth = 2
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.blackColor().CGColor
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.clipsToBounds = true
            downloadImage(checkedUrl)
        }
        print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
    }
    
    override func viewWillAppear(animated: Bool) {
        userName.text = mainInstance.first_name + " " + mainInstance.last_name
        print(mainInstance.first_name)
        print("Loaded")
    }
    
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func btnTouched(sender:UIButton!){
        FBSDKLoginManager().logOut()
        self.performSegueWithIdentifier("logout", sender: self);
    }
    
    func goHome(sender:UIButton!){
        print("Going Home")
        self.performSegueWithIdentifier("goHome22", sender: self);
    }
    
    //New
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //print(swiftBlogs[(tableView.indexPathForSelectedRow?.row)!])
        //print(segue.identifier)
        
        print(choosenRow)
        
        if(segue.identifier == "sample2"){
            let destination = segue.destinationViewController as! about
            destination.blogName = choosenRow
        }
        
        /*
        if segue.identifier == "sample2" {
            if let destination = segue.destinationViewController as? about {
                if let blogIndex = tableView.indexPathForSelectedRow {
                    destination.blogName = swiftBlogs[(tableView.indexPathForSelectedRow?.row)!]
                }
            }
        }
        else if swiftBlogs[(tableView.indexPathForSelectedRow?.row)!] == "ABOUT2" {
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("showAbout") as? about
            self.presentViewController(vc!, animated: true, completion: nil)
        }
        else if segue.identifier == blogSegueIdentifier {
            if let destination = segue.destinationViewController as? BlogViewController {
                if let blogIndex = tableView.indexPathForSelectedRow {
                    destination.blogName = swiftBlogs[(tableView.indexPathForSelectedRow?.row)!]
                }
            }
        }
        */
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
        print("--")
        //print(swiftBlogs[row])
        choosenRow = swiftBlogs[row]
        print("--")
        
        if(choosenRow == "ABOUT" || choosenRow == "WORK WITH US") {
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
