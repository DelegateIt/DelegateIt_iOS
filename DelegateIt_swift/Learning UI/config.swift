//
//  config.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 2/4/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftSpinner

class config{
    func getConfig(){
        if let path = NSBundle.mainBundle().pathForResource("config", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    let mode = jsonObj["mode"].stringValue
                    mainInstance.restURL = jsonObj[mode]["restURL"].stringValue
                    mainInstance.socketURL = jsonObj[mode]["socketURL"].stringValue
                } else {
                    //print("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            //print("Invalid filename/path.")
            SwiftSpinner.show("Config File Not Found")
        }
    }
}
