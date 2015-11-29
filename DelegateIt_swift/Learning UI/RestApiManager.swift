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
    
    let baseURL = "http://test-gator-api.elasticbeanstalk.com/"
    
    
    func createUser() {
        // Setup the session to make REST POST call
        let postEndpoint: String = "http://test-gator-api.elasticbeanstalk.com/core/login/customer"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["fbuser_id": "1237026922980425","fbuser_token": "CAANG1yne7NcBAIedDLJel0nmQ7dDVlcdy0w3AOlMyjmdO8cf60zx4MVLHYZATpZCZBdRxYzRhpodMjAsOliPr9Y6sMDnsSpNZBKvfwjg8lcJLmNGJlHVbsgdbZCvSCV6jaJIbKe1SnmslZAhX5ZAwMhnbZB9JMaNDLgiZByKQl9sp8672GZCFBKyKP2ErjNfcT4wsa7jesguTUYViB5wPLYTXu5vBZCclffpSsxRXwqoVZAvugZDZD","first_name":"Ben","last_name":"Wernsman","phone_number":"2144787761","email":"ben.wernsman@me.com"]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            //print(postParams)
        } catch {
            print("bad things happened")
        }
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("POST: " + postString)
                //self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
            }
            
        }).resume()
    }
    
    func getUser() {
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "http://test-gator-api.elasticbeanstalk.com/core/customer/12492214829628214231?token=MTI0OTIyMTQ4Mjk2MjgyMTQyMzE6Y3VzdG9tZXI6MTQ0ODc5NjIwNDpLL0srV2pLNUNsenppMnIrdUZ5SzNLb1l4WmdUQ3lVc2ZERGdFZVQzSm9BPQ=="
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                if let output = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                    // Print what we got from the call
                    print(output)
                    
                    // Parse the JSON to get the IP
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let first_name = jsonDictionary["first_name"] as! String
                    let last_name = jsonDictionary["last_name"] as! String
                    let phone_number = jsonDictionary["phone_number"] as! String
                    let uuid = jsonDictionary["uuid"] as! String
                    let active_transaction_uuids = jsonDictionary["active_transaction_uuids"] as! [String]
                    let activeCount = active_transaction_uuids.count
                    
                    mainInstance.setValues(first_name,last_name:last_name,uuid:uuid)
                    
                    // Update the label
                    //self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
}