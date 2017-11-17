//
//  ChatManager.swift
//  FDTX
//
//  Created by fandong on 2017/11/17.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import SocketIO

class ChatManager: NSObject {
    func connect() {
        let socket = SocketIOClient.init(socketURL: URL(string: "http://112.74.33.82:3000")!, config: [.log(true), .compress])
    }
}
