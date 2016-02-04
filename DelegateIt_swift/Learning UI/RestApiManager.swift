//
//  RestAPI.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/28/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import SwiftyJSON
import CWStatusBarNotification
import SystemConfiguration
import Alamofire

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    let notification = CWStatusBarNotification()
    
    var testURL = "http://192.168.99.100:8000";
    
    
    func loginUser(fbID:String,fbToken:String,first_name:String,last_name:String,email:String,callback: (Int) -> ()) {
        
        self.getUser2(fbID,fbToken: fbToken){ (response) in
            print(response)
        }
        
        print(fbID)
        print(fbToken)
        print("login")
        let URLCALL = "/core/login/customer";
        let parameters:[String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        var output:JSON = nil
        
        restAPICALL(URLCALL,paramaters: parameters,callType: "POST") { (response) in
            output = response
            
            if(output == nil){
                print("caught error")
                callback(-1)
                //Print error to try again
            }else{
                let result = output["result"].stringValue
                if(result == "0"){
                    print("User Login Successful")
                    let uuidTotal = output["customer"]["uuid"].stringValue
                    let token = output["token"].stringValue
                    self.getUser(uuidTotal, token: token)
                    mainInstance.setToken(token)
                    callback(1)
                }
                else if(result == "10"){
                    print("User is not created")
                    self.createUser(fbID as String,fbToken: fbToken,first_name:first_name,last_name:last_name,email:email)
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
    
    func getUser2(fbID:String,fbToken:String,callback: (JSON) -> ()){
        Alamofire.request(.POST, testURL + "/core/login/customer", parameters: ["fbuser_id":fbID,"fbuser_token":fbToken],encoding: .JSON)
            .responseJSON { response in
                callback(JSON(data:response.data!))
        }
    }
    
    func createUser(fbID:String,fbToken:String,first_name:String,last_name:String,email:String) {
        let URLCALL: String = "/core/customer"
        let parameters : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken,"first_name":first_name,"last_name":last_name,"email":email,"phone_number":"15555555551"]
        var output:JSON = nil
        print(parameters)
        restAPICALL(URLCALL,paramaters: parameters,callType: "POST") { (response) in
            output = response
            let result = output["result"].intValue
            
            if(result == 0){
                //user created and need to login
                self.loginUser(fbID,fbToken:fbToken,first_name:first_name,last_name:last_name,email:email){ (response) in
                    if(response == 1){
                        //successfull
                    }else{
                        //fail
                    }
                }
            }
            else if(result == 2){
                //User alread exists
            }
        }
    }
    
    
    func restAPICALL(URLCALL:String,paramaters:[String: String],callType:String,callback: (JSON) -> ()){
        let postEndpoint: String = testURL + URLCALL
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: String] = paramaters
        var json:JSON = nil
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = callType
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
        } catch {
            print("parameters are wrong")
        }
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) in
            // Read the JSON
            do {
                if(data != nil){
                    if let _ = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        json = JSON(jsonDictionary)
                        callback(json)
                    }
                } else{
                    print("No connection with DelegateIt server")
                    callback(nil)
                }
                
            } catch {
                print("No responce, check URL")
            }
        }).resume()
    }
    
    
    
    func getUser(uuid:String,token:String) {
        let postEndpoint: String = testURL + "/core/customer/" + uuid + "?token=" + token
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    let json = JSON(jsonDictionary)
                    let result = json["result"].stringValue
                
                    let first_name = json["customer"]["first_name"].stringValue
                    var email = ""
                    if(json["customer"]["email"] != nil){
                        email = json["customer"]["email"].stringValue
                    }
                    
                    let last_name = json["customer"]["last_name"].stringValue
                    let phone_number = json["customer"]["phone_number"].stringValue
                    let uuid = json["customer"]["uuid"].stringValue
                    var active_transaction_uuids = json["customer"]["active_transaction_uuids"].arrayValue.map { $0.string!}
                    let activeCount = active_transaction_uuids.count
                    
                    
                    mainInstance.setValues(first_name,last_name:last_name,uuid:uuid,active_transaction_uuids:active_transaction_uuids,activeCount:activeCount,email:email,phone_number:phone_number)
                    
                    var index:Int
                    
                    for index = 0; index < active_transaction_uuids.count; index++ {
                        self.getTransaction(active_transaction_uuids[index], token: mainInstance.token)
                    }
                    sockets().startSockets()
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
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
                        self.sendMessage(transactionUUID,token: mainInstance.token,message: newMessage)
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
    
    
    func getTransaction(transactionUUID:String,token:String) {
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        print(token)
        let postEndpoint: String = testURL + "/core/transaction/" + transactionUUID + "?token=" + token
        print(postEndpoint)
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    print("-----")
                    let json = JSON(jsonDictionary)
                    let result = json["result"].stringValue
                    print(json)
                    print("Got data")
                    
                    
                    mainInstance.active_transaction_uuids2.append(transaction(dataInput: json))
                    

    
                    //print(mainInstance.active_transaction_uuids2[0].first_name)
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
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
        // Setup the session to make REST POST call
        let postEndpoint: String = testURL + "/core/customer/" + mainInstance.uuid + "?token=" + mainInstance.token
        print(postEndpoint)
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        //let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        
        var result:Int = -1
        
        var updatedType = "email"
        
        if(userProfileUpdate == "FIRST NAME"){
            updatedType = "first_name"
            mainInstance.first_name = updatedInformation
        }else if(userProfileUpdate == "LAST NAME"){
            updatedType = "last_name"
            mainInstance.last_name = updatedInformation
        }
        
        //Actual User
        let postParams : [String: String] = [updatedType:updatedInformation]
        
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
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
                    }
                }
            } catch {
                print("bad things happened")
            }
            
            //Result 10 means to create a new user
            //Result 0 is good
            
            
        }).resume()
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