//
//  ChatManager.swift
//  FDTX
//
//  Created by fandong on 2017/11/17.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import SocketIO

private let defaultManager = ChatManager()

class ChatManager {
    
    let socket = SocketIOClient.init(socketURL: URL.init(string: "http://112.74.33.82:3000")!, config: SocketIOClientConfiguration.init(arrayLiteral: .log(true),.forcePolling(true)))
    
    class var manager : ChatManager {
        return defaultManager
    }
}

extension ChatManager {
    
    func connect() {
        socket.connect()
    }
    
}
