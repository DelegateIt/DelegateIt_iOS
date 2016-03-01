//
//  notificationHandler.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 1/12/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation
import CWStatusBarNotification

class notificationHandler {
    let notification = CWStatusBarNotification()
    func printHello(name:String){
        print("Display Notification")
        self.notification.notificationStyle = .NavigationBarNotification
        self.notification.notificationLabelBackgroundColor = UIColor.blueColor()
        self.notification.displayNotificationWithMessage(name, completion: nil)
        self.notification.notificationTappedBlock = {
            //print("notification tapped")
            self.notification.dismissNotification()
        }
    }
}

var notificationH = notificationHandler()