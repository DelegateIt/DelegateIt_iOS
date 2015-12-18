//
//  global.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/28/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation


class Main {
    //User info
    var first_name:String = ""
    var last_name:String = ""
    var name:String = ""
    var phone_number:String = ""
    var email:String = ""
    var uuid:String = ""
    var activeCount:Int = 0
    var active_transaction_uuids:[String] = []
    var token:String = ""
    var currentMessage:Int = -1
    
    var currentTransaction:String = ""
    var messageQue:[String] = []
    
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
    
    func setCurrentTransaction(currentTransaction:String){
        self.currentTransaction = currentTransaction
    }
    
    func setMessageCount(currentMessage:Int){
        self.currentMessage = currentMessage
    }
    
    func addMessage(){
        self.currentMessage = self.currentMessage + 1
    }
    

    
    /*
    
    func nameChecker() -> String {
        if(self.last_name == ""){
            self.name = self.first_name
        }else{
            self.name = self.first_name + " " + self.last_name
        }
        return self.name
    }
    
    func setName(first_name:String) -> String{
        self.first_name = first_name
        return self.first_name
    }
    
    func getName() -> String {
        return self.first_name
    }
    */
}

var mainInstance = Main()