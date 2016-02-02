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
    static let rCall = restAPI()
    
    var testURL = "http://192.168.99.100:8000";
    
    func getUser(callback: (String) -> ()){
        Alamofire.request(.GET, testURL + "/core/login/customer", parameters: ["fbuser_id":mainInstance.fbID,"fbuser_token":mainInstance.fbToken])
            .response { request, response, data, error in
                print("_testing_")
                print(request)
                print(response)
                print(data)
                print(error)
                
                callback("Hey123->")
        }
    }
}
