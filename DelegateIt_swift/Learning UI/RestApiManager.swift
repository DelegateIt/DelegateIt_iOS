//
//  RestAPI.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/28/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation


typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    func loginUser(fbID:String,fbToken:String,first_name:String,last_name:String,email:String) {
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://test-gator-api.elasticbeanstalk.com/core/login/customer"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        
        //Test User
        //let postParams : [String: String] = ["fbuser_id":"123413948026148","fbuser_token":"CAANG1yne7NcBAFWZCQ1YMudJZBQeOLMaY8YQ28aQrYfPksmXSCFIavQ0vjRbywpqtioW6zvkJX57PFKimGHnOCuu3BD9yXCQTogfYHcGR3qvg8bpCxYodKkZAB4hnQ0m8scmmeHl4qSym9AGZBxo3jVKTuH7c9JXcrnXJ3FobVZBhab0tVnt4H3kTBNip51o1tOY3IOZChSOATsRGQcsqU"]
    
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
                print("--a----")
                print(output)
                    
                // Parse the JSON to get the IP
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let result = jsonDictionary["result"] as! Int
                print(jsonDictionary)
                
                if(result == 0){
                    print("User is ballin")
                    //var getUUID:[NSString] = output
                    //print(getUUID)
                    
                    //var uuidTotal = jsonDictionary['uuid'] as! String
                    //print(uuidTotal)
                    let token = jsonDictionary["token"] as! String
                    self.getUser("12492214829628214231", token: token) //CHANGE
                    //save data
                    
                }
                else if(result == 10){
                    print("User is not created")
                    self.createUser(fbID as String,fbToken: fbToken,first_name:first_name,last_name:last_name,email:email)
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
    }
    
    func createUser(fbID:String,fbToken:String,first_name:String,last_name:String,email:String) {
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://test-gator-api.elasticbeanstalk.com/core/customer"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        //let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken]
        
        //Actual User
        let postParams : [String: String] = ["fbuser_id":fbID,"fbuser_token":fbToken,"first_name":first_name,"last_name":last_name,"email":email,"phone_number":"1111111111"]
        
        
        //Test User
        //let postParams : [String: String] = ["fbuser_id":"123413948026148","fbuser_token":"CAANG1yne7NcBAFWZCQ1YMudJZBQeOLMaY8YQ28aQrYfPksmXSCFIavQ0vjRbywpqtioW6zvkJX57PFKimGHnOCuu3BD9yXCQTogfYHcGR3qvg8bpCxYodKkZAB4hnQ0m8scmmeHl4qSym9AGZBxo3jVKTuH7c9JXcrnXJ3FobVZBhab0tVnt4H3kTBNip51o1tOY3IOZChSOATsRGQcsqU","first_name":first_name,"last_name":last_name,"email":email,"phone_number":"1111111111"]
        
        
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
                    let result = jsonDictionary["result"] as! Int
                    
                    if(result == 0){
                        print("User created")
                        self.loginUser(fbID,fbToken:fbToken,first_name:first_name,last_name:last_name,email:email)
                    }
                    else if(result == 2){
                        print("User alread exists")
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
    }
    
    
    
    func getUser(uuid:String,token:String) {
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        print(uuid)
        print(token)
        let postEndpoint: String = "http://test-gator-api.elasticbeanstalk.com/core/customer/" + uuid + "?token=" + token
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
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    print(jsonDictionary)
                    let first_name = jsonDictionary["first_name"] as! String
                    var email = ""
                    if(jsonDictionary["email"] != nil){
                        email = jsonDictionary["email"] as! String
                    }
                    
                    let last_name = jsonDictionary["last_name"] as! String
                    let phone_number = jsonDictionary["phone_number"] as! String
                    let uuid = jsonDictionary["uuid"] as! String
                    let active_transaction_uuids = jsonDictionary["active_transaction_uuids"] as! [String]
                    let activeCount = active_transaction_uuids.count
                    
                    
                    mainInstance.setValues(first_name,last_name:last_name,uuid:uuid,active_transaction_uuids:active_transaction_uuids,activeCount:activeCount,email:email,phone_number:phone_number)
                    
                    print("Got data")
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
}