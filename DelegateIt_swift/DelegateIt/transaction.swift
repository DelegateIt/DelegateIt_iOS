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
    var timeStamp:Double = 0.0
    var messageCount:Int = 0
    var messages:JSON
    
    var lastMessage:String = "No messages"
    var lastTimeStamp:Double = 0.0
    
    
    init(dataInput:JSON){
        self.paymentStatus = dataInput["status"].stringValue
        self.paymentURL = dataInput["payment_url"].stringValue
        self.transactionUUID = dataInput["uuid"].stringValue
        self.timeStamp = dataInput["timestamp"].doubleValue
        self.messageCount = dataInput["messages"].count
        self.messages = dataInput["messages"]
        
        print(messageCount)
        
        if(self.messageCount > 0){
           getLastMessage()
        }
    }
    
    func getLastMessage(){
        messageCount = messages.count
        self.lastMessage = messages[messageCount-1]["content"].stringValue
        self.lastTimeStamp = messages[messageCount-1]["timestamp"].doubleValue
    }
    
    
}
