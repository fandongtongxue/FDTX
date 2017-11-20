//
//  ChatDetailViewController.swift
//  FDTX
//
//  Created by fandong on 2017/11/17.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import SocketIO

class ChatDetailViewController: BaseViewController {
    
    let socket = SocketIOClient.init(socketURL: URL.init(string: "http://112.74.33.82:3000")!, config: SocketIOClientConfiguration.init(arrayLiteral: .log(true),.forcePolling(true)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        navigationItem.title = "Chat Detail"
        
        socket.on("connect") { (data, SocketAckEmitter) in
            log.info("connect")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        socket.on("disconnect") { (data, SocketAckEmitter) in
            log.info("disconnect")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        socket.on("user joined") { (data, SocketAckEmitter) in
            log.info("user joined")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        socket.on("login") { (data, SocketAckEmitter) in
            log.info("login")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        socket.on("new message") { (data, SocketAckEmitter) in
            log.info("new message")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        socket.on("user left") { (data, SocketAckEmitter) in
            log.info("user left")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        socket.on("typing") { (data, SocketAckEmitter) in
            log.info("typing")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        socket.on("stop typing") { (data, SocketAckEmitter) in
            log.info("stop typing")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        socket.on("reconnect") { (data, SocketAckEmitter) in
            log.info("reconnect")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        socket.on("reconnect_error") { (data, SocketAckEmitter) in
            log.info("reconnect_error")
            log.info(data)
            log.info(SocketAckEmitter)
        }
        
        socket.connect()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
}
