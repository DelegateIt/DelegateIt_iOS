    //
//  AppDelegate.swift
//  Learning UI
//
//  Created by Ben Wernsman on 11/9/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import UIKit
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        if NSUserDefaults.standardUserDefaults().objectForKey("launchCount")?.integerValue >= 3{
            if UIApplication.sharedApplication().respondsToSelector(#selector(UIApplication.isRegisteredForRemoteNotifications)) {
                UIApplication.sharedApplication().registerUserNotificationSettings(
                    UIUserNotificationSettings(
                        forTypes: [.Alert, .Badge, .Sound],
                        categories: nil))
                UIApplication.sharedApplication().registerForRemoteNotifications()
            }
        }
        
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        //socketManager.socket.disconnect()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        socketManager.stopSockets()
    }
    

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let deviceTokenStr = convertDeviceTokenToString(deviceToken)
        mainInstance.deviceID = deviceTokenStr
        
        //callback
        if(!mainInstance.loggingIn){
            mainInstance.loggingIn = true
            
        }
        
        mainInstance.loginReady = true
        
        NSNotificationCenter.defaultCenter().postNotificationName("readyToLogin", object: nil)
        
        //facebookLogin().loginUser()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //no token
        //print("Failed")
        if(!mainInstance.loggingIn){
            mainInstance.loggingIn = true
        }
        
        mainInstance.loginReady = true
        
        NSNotificationCenter.defaultCenter().postNotificationName("readyToLogin", object: nil)
        
        //facebookLogin().loginUser()
    }
    
    
    // Called when a notification is received and the app is in the
    // foreground (or if the app was in the background and the user clicks on the notification).
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // display the userInfo
        
        if let notification = userInfo["aps"] as? NSDictionary,
            let alert = notification["alert"] as? String {

                let messageText = notification["message"] as? NSString
            
                if(!mainInstance.autoDismiss){
                    let alertCtrl = UIAlertController(title: "New Message", message: alert as String, preferredStyle: UIAlertControllerStyle.Alert)
                    alertCtrl.addAction(UIAlertAction(title: "Go to Message", style: UIAlertActionStyle.Default, handler: printH))
                    alertCtrl.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    
                    // Find the presented VC...
                    var presentedVC = self.window?.rootViewController
                    while (presentedVC!.presentedViewController != nil)  {
                        presentedVC = presentedVC!.presentedViewController
                    }
                    presentedVC!.presentViewController(alertCtrl, animated: true, completion: nil)
                    
                    mainInstance.gotoOrders = true
                }
            
            
                // call the completion handler
                // -- pass in NoData, since no new data was fetched from the server.
                completionHandler(UIBackgroundFetchResult.NoData)
        }
    }
    
    func printH(alert: UIAlertAction!){
        mainInstance.gotoOrders = true
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabBarController") as UIViewController
        rootVC.view.frame = UIScreen.mainScreen().bounds
        UIView.transitionWithView(self.window!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
            self.window!.rootViewController = rootVC
            }, completion: nil)
    }
    
    
    private func convertDeviceTokenToString(deviceToken:NSData) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        var deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString(">", withString: "", range: nil)
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "", range: nil)
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "", range: nil)
        
        // Our API returns token in all uppercase, regardless how it was originally sent.
        // To make the two consistent, I am uppercasing the token string here.
        deviceTokenStr = deviceTokenStr.uppercaseString
        
        print(deviceTokenStr)
        
        return deviceTokenStr
    }
    
}
