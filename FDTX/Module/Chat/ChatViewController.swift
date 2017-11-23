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

class ChatViewController: BaseViewController {
    
    var initialCount = 0
    let pageSize = 50
    var dataSource: FakeDataSource!
    
    var chatController = DemoChatViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        navigationItem.title = "Chat Selected"
        
        connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //如果Socket断开连接,就重新连接
    }
    
    func connect() {
        ChatManager.manager.connect()
        ChatManager.manager.socket.emit("add user", UserDefault.shared.objectFor(key: USER_DEFAULT_KEY_NICKNAME))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if dataSource == nil {
            dataSource = FakeDataSource(count: initialCount, pageSize: pageSize)
        }
        chatController.dataSource = dataSource
        chatController.messageSender = dataSource.messageSender
        chatController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatController, animated: true)
        return
        
        let chatDetailVC = ChatDetailViewController()
        chatDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatDetailVC, animated: true)
    }
}
