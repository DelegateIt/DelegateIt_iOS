//
//  global.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/28/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation
import SwiftyJSON


class Main {
    var first_name:String = ""
    var last_name:String = ""
    var name:String = ""
    var phone_number:String = ""
    var email:String = ""
    var uuid:String = ""
    var activeCount:Int = 0
    var active_transaction_uuids:[String] = []
    var active_transaction_uuids2:[transaction] = []
    var token:String = ""
    var currentMessage:Int = -1
    var currentTransactionUUID:String = ""
    
    var currentTransaction:transaction = transaction(dataInput: "")
    var messageQue:[String] = []
    
    var deviceID:String = ""
    
    var restURL = ""
    var socketURL = ""
    var debubMode = false
    
    var profilePic:UIImage = UIImage()
    var delegateItWebsite:NSURLRequest = NSURLRequest()
    
    
    var loggingIn:Bool = false
    
    var comingfrom:String = "popular"
    
    var gotoOrders:Bool = false
    
    var isHelpShowing:Bool = false
    
    //Facebook info
    var fbID:String = ""
    var fbToken:String = ""
    
    init() {
    }
    
    
    func printHello(){
        print("Hello")
    }
    
    func loadFB(fbID:String,fbToken:String){
        self.fbID = fbID
        self.fbToken = fbToken
        
        print("Check Values")
        print(self.fbID)
        print(self.fbToken)
    }
    
    func setValues(first_name:String,last_name:String,uuid:String,active_transaction_uuids:[String],activeCount:Int,email:String,phone_number:String) {
        self.uuid = uuid
        self.first_name = first_name
        self.last_name = last_name
        self.active_transaction_uuids = active_transaction_uuids
        self.activeCount = activeCount
        self.email = email
        self.phone_number = phone_number
        print(active_transaction_uuids)
        print(activeCount)
        print(first_name)
        print(last_name)
    }
    
    func emptyData(){
        print("EMPTY")
        self.active_transaction_uuids = []
        self.active_transaction_uuids2 = []
        self.currentTransaction = transaction(dataInput: "")
        self.fbID = ""
        self.fbToken = ""
        self.loggingIn = false
    }
    
    func addtoQue(message:String){
        self.messageQue.append(message)
    }
    
    func getMessages() -> String{
        if(self.currentMessage < self.messageQue.count){
            return self.messageQue[self.currentMessage]
        }
        return ""
    }
    
    
    func setToken(token:String) {
        self.token = token
    }
    
    func setMessageCount(currentMessage:Int){
        self.currentMessage = currentMessage
    }
    
    func addMessage(){
        self.currentMessage = self.currentMessage + 1
    }
    
    func findTransaction(UUID:String) -> transaction {
        activeCount = active_transaction_uuids2.count
        var index = 0
        for(index = 0; index < activeCount; index++){
            if(active_transaction_uuids2[index].transactionUUID == UUID){
                return active_transaction_uuids2[index]
            }
        }
        return active_transaction_uuids2[0]
    }
    
    func getIndex(UUID:String) -> Int {
        var index = 0
        for(index = 0; index < active_transaction_uuids2.count; index++){
            if(active_transaction_uuids2[index].transactionUUID == UUID){
                return index
            }
        }
        return -1
    }
    
    
    
    func updateTransaction(newTransaction:JSON){
        //print(newTransaction[0])
        let currentUUID = newTransaction[0]["uuid"].stringValue
        var index = 0
        for(index = 0; index < active_transaction_uuids2.count; index++){
            if(active_transaction_uuids2[index].transactionUUID == currentUUID){
                print(newTransaction[0]["status"].stringValue)
                print(newTransaction[0]["messages"])
                active_transaction_uuids2[index].messages = newTransaction[0]["messages"]
                active_transaction_uuids2[index].getLastMessage()
                print(active_transaction_uuids2[index].messages)
                NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
            }
        }
        self.sortTransaction()
    }
    
    func sortTransaction(){
        active_transaction_uuids2.sortInPlace({$0.lastTimeStamp > $1.lastTimeStamp})
    }
}

var mainInstance = Main()