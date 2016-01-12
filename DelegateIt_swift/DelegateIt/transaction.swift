//
//  transaction.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 1/12/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation
import SwiftyJSON

class transaction {
    var paymentURL:String = ""
    var paymentStatus:String = ""
    var transactionUUID:String = ""
    var timeStamp:String = ""
    var messageCount:Int = 0
    var messages:JSON
    
    var lastMessage:String = "No messages"
    var lastTimeStamp:String = ""
    
    
    
    init(dataInput:JSON){
        self.paymentStatus = dataInput["transaction"]["status"].stringValue
        self.paymentURL = dataInput["transaction"]["payment_url"].stringValue
        self.transactionUUID = dataInput["transaction"]["uuid"].stringValue
        self.timeStamp = dataInput["transaction"]["timestamp"].stringValue
        self.messageCount = dataInput["transaction"]["messages"].count
        self.messages = dataInput["transaction"]["messages"]
        
        print(messageCount)
        
        if(self.messageCount > 0){
           getLastMessage()
        }
        
        
        /*
        print(paymentStatus)
        print(paymentURL)
        print(transactionUUID)
        print(messageCount)
        print(messages[1]["content"])
        */
    }
    
    func getLastMessage(){
        self.lastMessage = messages[messageCount-1]["content"].stringValue
        self.lastTimeStamp = messages[messageCount-1]["timestamp"].stringValue
    }
    
    
}
