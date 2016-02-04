//
//  restAPI.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 2/2/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class restAPI{

    var testURL = "http://192.168.99.100:8000";
    //let json = JSON(data: dataFromNetworking)
    
    func getUser(callback: (JSON) -> ()){
        Alamofire.request(.GET, testURL + "/core/login/customer", parameters: ["fbuser_id":mainInstance.fbID,"fbuser_token":mainInstance.fbToken])
            .response { request, response, data, error in
                print("------____------")
                print(data)
                if let value = data {
                    let json = JSON(value)
                    print("JSON: \(json)")
                }
                callback("Hey")
        }
    }
}

var restCall = restAPI()
