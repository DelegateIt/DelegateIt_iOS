//
//  sockets.swift
//  DelegateIt
//
//  Created by Ben Wernsman on 1/27/16.
//  Copyright © 2016 Ben Wernsman. All rights reserved.
//

import Foundation
import SocketIOClientSwift
import SwiftyJSON

class sockets{
    var socket = SocketIOClient(socketURL: NSURL(string: mainInstance.socketURL)!,
                                options:[
                                .Log(true),
                                .ForcePolling(true),
                                .ForceNew(true)
                                ])

    func startSockets(){
        socket.on("connect") {data, ack in
            print("socket connected")
            print(mainInstance.active_transaction_uuids2.count)
            var index = 0
            for index = 0; index < mainInstance.active_transaction_uuids2.count; index += 1 {
                self.socket.on(mainInstance.active_transaction_uuids2[index].transactionUUID) {data, ack in
                    let json = JSON(data)
                    mainInstance.updateTransaction(json)
                }
                self.socket.emit("register_transaction", ["transaction_uuid": mainInstance.active_transaction_uuids2[index].transactionUUID])
            }
        }
        socket.connect()
    }
    
    func addTransaction(transaction:String) {
        self.socket.on(transaction) {data, ack in
            let json = JSON(data)
            mainInstance.updateTransaction(json)
        }
        self.socket.emit("register_transaction", ["transaction_uuid": transaction])
    }
    
    func stopSockets(){
        socket.disconnect()
    }
}

var socketManager = sockets()
