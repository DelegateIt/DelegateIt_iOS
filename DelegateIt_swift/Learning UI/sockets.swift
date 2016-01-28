//
//  sockets.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 1/27/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift
import SwiftyJSON
import CWStatusBarNotification


class sockets{
    
    var socketURL = "http://192.168.99.100:8060"
    let notification = CWStatusBarNotification()
    
    
    //SocketIO
    func startSockets() {
        let socket = SocketIOClient(socketURL: socketURL, options: [.Log(false), .ForcePolling(false)])
        socket.on("connect") {data, ack in
            print("socket connected")
            var index = 0
            for index = 0; index < mainInstance.active_transaction_uuids.count; index++ {
                socket.on(mainInstance.active_transaction_uuids[index]) {data, ack in
                    let json = JSON(data)
                    var messageContent = json[0]["messages"][json[0]["messages"].count - 1]["content"]
                    
                    print("_----_")
                    
                    
                    
                    mainInstance.updateTransaction(json)
                    
                    
                    print("__----_")
                    
                    
                    //mainInstance.active_transaction_uuids2.append(transaction(dataInput: json))
                    
                    //print(json[0]["uuid"].stringValue)
                    //print(mainInstance.getIndex(json[0]["uuid"].stringValue))
                    //print(mainInstance.active_transaction_uuids2[mainInstance.getIndex(json[0]["uuid"].stringValue)].transactionUUID)
                    
                    //print("----")
                    //print(json[0]["uuid"].stringValue)
                    //print(mainInstance.active_transaction_uuids2[mainInstance.getIndex(json[0]["uuid"].stringValue)].lastMessage)
                    
                    //self.notification.notificationStyle = .NavigationBarNotification
                    
                    var index2 = 0
                    
                    for(index = 0; index < mainInstance.active_transaction_uuids2.count; index++){
                        //print(mainInstance.active_transaction_uuids2[index].transactionUUID)
                        //print(mainInstance.active_transaction_uuids2[index].messages)
                    }
                    
                    
                    
                    self.notification.notificationTappedBlock = {
                        print("notification tapped")
                        // more code here
                        self.notification.dismissNotification()
                    }
                    self.notification.notificationLabelBackgroundColor = UIColor.blueColor()
                    self.notification.displayNotificationWithMessage("NEW MESSAGE: \(messageContent)", completion: nil)
                }
                socket.emit("register_transaction", ["transaction_uuid": mainInstance.active_transaction_uuids[index]])
            }
        }
        socket.connect()
    }
}
