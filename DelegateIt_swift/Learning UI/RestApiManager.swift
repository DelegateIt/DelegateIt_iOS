//
//  RestAPI.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/28/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import SwiftyJSON
import SystemConfiguration
import Alamofire

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    var testURL = mainInstance.restURL
    
    func apiCall(URLCALL:String,paramaters:[String: String],callType:String,callback: (JSON) -> ()){
        if(callType == "POST"){
            Alamofire.request(.POST, testURL + URLCALL, parameters: paramaters,encoding: .JSON)
                .responseJSON { response in
                    callback(JSON(data:response.data!))
            }
        }
        else if(callType == "GET"){
            Alamofire.request(.GET, testURL + URLCALL)
                .responseJSON { response in
                    callback(JSON(data:response.data!))
            }
        }
        else if(callType == "PUT"){
            print(URLCALL)
            Alamofire.request(.PUT, testURL + URLCALL, parameters: paramaters,encoding: .JSON)
                .responseJSON { response in
                    callback(JSON(data:response.data!))
            }
        }
    }
    
    
    func loginUser(fbID:String,fbToken:String,first_name:String,last_name:String,email:String,callback: (Int) -> ()) {
        let URLCALL = "/core/login/customer";
        let parameters:[String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        var output:JSON = nil
        
        apiCall(URLCALL,paramaters: parameters,callType: "POST") { (response) in
            output = response
            print(output)
            if(output == nil){
                //Print error to try again
                callback(-1)
                
            }else{
                let result = output["result"].stringValue
                if(result == "0"){
                    print("User Login Successful")
                    let uuidTotal = output["customer"]["uuid"].stringValue
                    let token = output["token"].stringValue
                    let first_name = output["customer"]["first_name"].stringValue
                    var email = ""
                    if(output["customer"]["email"] != nil){
                        email = output["customer"]["email"].stringValue
                    }
                    let last_name = output["customer"]["last_name"].stringValue
                    let phone_number = output["customer"]["phone_number"].stringValue
                    let uuid = output["customer"]["uuid"].stringValue
                    var active_transaction_uuids = output["customer"]["active_transaction_uuids"].arrayValue.map { $0.string!}
                    let activeCount = active_transaction_uuids.count
                    
                    mainInstance.setToken(token)
                    mainInstance.setValues(first_name,last_name:last_name,uuid:uuid,active_transaction_uuids:active_transaction_uuids,activeCount:activeCount,email:email,phone_number:phone_number)
                    
                    var index:Int
                    
                    for index = 0; index < active_transaction_uuids.count; index++ {
                        self.getTransaction(active_transaction_uuids[index], token: mainInstance.token)
                    }
                    
                    sockets().startSockets()
                    callback(1)
                }
                else if(result == "10"){
                    print("User is not created")
                    self.createUser(fbID as String,fbToken: fbToken,first_name:first_name,last_name:last_name,email:email){ (response) in
                        self.loginUser(fbID as String,fbToken: fbToken,first_name:first_name,last_name:last_name,email:email) { (response) in
                            callback(response)
                        }
                        callback(response)
                    }
                }
                else{
                    //login failed
                    //return 0
                }
                //Result 10 means to create a new user
                //Result 0 is good
            }
            

        }
    }
    
    
    
    func createUser(fbID:String,fbToken:String,first_name:String,last_name:String,email:String,callback: (Int) -> ()) {
        let URLCALL: String = "/core/customer"
        let parameters : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken,"first_name":first_name,"last_name":last_name,"email":email]
        var output:JSON = nil
        print(parameters)
        apiCall(URLCALL,paramaters: parameters,callType: "POST") { (response) in
            output = response
            let result = output["result"].intValue
            
            print("Create User")
            print(output)
            
            if(result == 0 || result == 2){
                //user created and need to login
                self.loginUser(fbID,fbToken:fbToken,first_name:first_name,last_name:last_name,email:email){ (response) in
                    if(response == 1){
                        //successfull
                        print("Success")
                        callback(1)
                        
                    }else{
                        //fail
                        print("Fail")
                        callback(response)
                    }
                }
            }
            else if(result == -1){
                //User alread exists
                callback(1)
            }
            callback(0)
        }
    }
    
    
    func getTransaction(transactionUUID:String,token:String) {
        let URLCALL: String = "/core/transaction/" + transactionUUID + "?token=" + token
        let parameters : [String: String] = ["":""]
        var output:JSON = nil
        apiCall(URLCALL,paramaters: parameters,callType: "GET") { (response) in
            output = response
            let result = output["result"].intValue
            
            if(result == 0){
                print("APPPPPPPP")
                mainInstance.active_transaction_uuids2.append(transaction(dataInput: output))
            }
            else{
                print("error")
            }
        }
    }
    



    func createTransaction(uuid:String,token:String,newMessage:String) -> String {
        // Setup the session to make REST POST call
        let postEndpoint: String = testURL + "/core/transaction?token=" + token
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        //let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        
        var result:Int = -1
        var transactionUUID:String = ""
        
        //Actual User
        let postParams : [String: String] = ["customer_uuid":uuid,"customer_platform_type":"ios"]
        
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    result = jsonDictionary["result"] as! Int
                    
                    if(result == 0){
                        print("Transaction created")
                        transactionUUID = jsonDictionary["uuid"] as! String
                        print(transactionUUID)
                        mainInstance.active_transaction_uuids.append(transactionUUID)
                        sockets().startSockets()
                        if(self.sendMessage(transactionUUID,token: mainInstance.token,message: newMessage) == 1){
                            
                        }
                        self.getTransaction(transactionUUID,token: mainInstance.token)
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("loadbadge", object: nil)
                        NSNotificationCenter.defaultCenter().postNotificationName("updateTransaction", object: nil)
                    }
                    print("Got data")
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
            
            //Result 10 means to create a new user
            //Result 0 is good
            
            
        }).resume()
        
        if(result == 0){
            return transactionUUID
        }
        return ""
    }
    
    
    
    
    func sendMessage(transactionUUID:String,token:String,message:String) -> Int {
        // Setup the session to make REST POST call
        let postEndpoint: String = testURL + "/core/send_message/" + transactionUUID + "?token=" + token
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        //let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        
        var result:Int = -1
        
        //Actual User
        let postParams : [String: String] = ["type":"text","content":message,"from_customer":"true"]
        
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    result = jsonDictionary["result"] as! Int
                    
                    if(result == 0){
                        print("Message Sent")
                        mainInstance.addMessage()
                        let nextMessage:String = mainInstance.getMessages()
                        if(nextMessage != ""){
                            self.sendMessage(mainInstance.currentTransaction.transactionUUID,token: mainInstance.token,message: nextMessage)
                        }
                    }
                    print("Got data")
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
            
            //Result 10 means to create a new user
            //Result 0 is good
            
            
        }).resume()
        
        if(result == 0){
            return 1
        }
        return 0
    }
    
    func updateUser(userProfileUpdate:String,updatedInformation:String) {
        let URLCALL: String = "/core/customer/" + mainInstance.uuid + "?token=" + mainInstance.token
        
        var output:JSON = nil
        
        var updatedType = "email"
        
        if(userProfileUpdate == "FIRST NAME"){
            updatedType = "first_name"
            mainInstance.first_name = updatedInformation
        }else if(userProfileUpdate == "LAST NAME"){
            updatedType = "last_name"
            mainInstance.last_name = updatedInformation
        }
        
        let parameters : [String: String] = [updatedType:updatedInformation]
        
        apiCall(URLCALL,paramaters: parameters,callType: "PUT") { (response) in
            output = response
            print(output)
            let result = output["result"].intValue
            
            if(result == 0){
                print("It worked")
            }
            else{
                print("error")
            }
        }
    }
    

    
    //Check For Internet Connection
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}