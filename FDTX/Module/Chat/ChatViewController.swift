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

let ChatViewControllerCellId = "ChatViewControllerCellId"

class ChatViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var initialCount = 0
    let pageSize = 50
    var dataSource: FakeDataSource!
    
    var chatController = DemoChatViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        navigationItem.title = "Chat Selected"
        
        ChatManager.manager.connect()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        dataArray = NSMutableArray.init(array: ["欢迎来到范东同学的 Socket.IO 聊天室"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //如果Socket断开连接,就重新连接
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatViewControllerCellId)
        let title = self.dataArray.object(at: indexPath.row) as! String
        cell?.selectionStyle = .none
        cell?.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        cell?.textLabel?.mixedTextColor = MixedColor.init(normal: .lightGray, night: .black)
        cell?.textLabel?.text = title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if dataSource == nil {
                dataSource = FakeDataSource(count: initialCount, pageSize: pageSize)
            }
            chatController.dataSource = dataSource
            chatController.messageSender = dataSource.messageSender
            chatController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatController, animated: true)
            break
        default:
            //do nothing
//            let chatDetailVC = ChatDetailViewController()
//            chatDetailVC.hidesBottomBarWhenPushed = true
//            navigationController?.pushViewController(chatDetailVC, animated: true)
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: ChatViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    lazy var dataArray : NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
}
