//
//  ChatViewController.swift
//  FDTX
//
//  Created by 范东 on 2017/11/14.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import SocketIO

class ChatViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title = "Chat Selected"
        test()
    }
    
    func test() {
        let socket = SocketIOClient.init(socketURL: URL(string: "http://112.74.33.82:3000")!, config: [.log(true), .compress])
        socket.on("connect") { (data, emitter) in
            print(data)
            print(emitter)
        }
        socket.connect(timeoutAfter: 5) {
            //
            print("")
        }
    }
}
