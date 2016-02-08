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

class sockets{
    
    var socketURL = mainInstance.socketURL

    func startSockets() {
        let socket = SocketIOClient(socketURL: socketURL, options: [.Log(false), .ForcePolling(true)])
        socket.on("connect") {data, ack in
            print("socket connected")
            var index = 0
            for index = 0; index < mainInstance.active_transaction_uuids.count; index++ {
                socket.on(mainInstance.active_transaction_uuids[index]) {data, ack in
                    let json = JSON(data)
                    //var count = json[0]["messages"].count - 1
                    //if(!json[0]["messages"][count]["from_customer"].boolValue){
                        mainInstance.updateTransaction(json)
                    //}
                    
                    
                }
                socket.emit("register_transaction", ["transaction_uuid": mainInstance.active_transaction_uuids[index]])
            }
        }
        socket.connect()
    }
}
