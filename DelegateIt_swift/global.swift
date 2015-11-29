//
//  global.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 11/28/15.
//  Copyright © 2015 Ben Wernsman. All rights reserved.
//

import Foundation


class Main {
    var first_name:String = ""
    var last_name:String = ""
    var name:String = ""
    var phone_number:String = ""
    var email:String = ""
    var uuid:String = ""
    var activeCount:Int = 0
    var active_transaction_uuids:[String] = []
    init() {
    }
    
    func printHello(){
        print("Hello")
    }
    
    func setValues(first_name:String,last_name:String,uuid:String) {
        self.uuid = uuid
        self.first_name = first_name
        self.last_name = last_name
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