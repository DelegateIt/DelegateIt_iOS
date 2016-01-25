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
        self.paymentStatus = dataInput["transaction"]["status"].stringValue
        self.paymentURL = dataInput["transaction"]["payment_url"].stringValue
        self.transactionUUID = dataInput["transaction"]["uuid"].stringValue
        self.timeStamp = dataInput["transaction"]["timestamp"].doubleValue
        self.messageCount = dataInput["transaction"]["messages"].count
        self.messages = dataInput["transaction"]["messages"]
        
        print(messageCount)
        
        if(self.messageCount > 0){
           getLastMessage()
        }
    }
    
    func getLastMessage(){
        self.lastMessage = messages[messageCount-1]["content"].stringValue
        self.lastTimeStamp = messages[messageCount-1]["timestamp"].doubleValue
    }
    
    
}
