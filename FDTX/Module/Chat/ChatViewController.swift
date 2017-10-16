//
//  ChatViewController.swift
//  FDTX
//
//  Created by fandong on 2017/10/16.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class ChatViewController: BaseViewController {
    //TCP服务端
    var server:SynchronousTCPServer!
    
    //TCP客户端
    lazy var client:TCPClient? = {
        //初始化客户端
        let address = InternetAddress(hostname: "127.0.0.1", port: 8080)
        do {
            return try TCPClient(address: address)
        } catch {
            print("Error \(error)")
            return nil
        }
    }()
    
    lazy var textField : UITextField = {
        let textField = UITextField.init(frame: .zero)
        textField.mixedTextColor = MixedColor.init(normal: .white, night: .black)
        textField.mixedBackgroundColor = MixedColor.init(normal: .black, night: .green)
        return textField
    }()
    
    lazy var textView : UITextView = {
        let textView = UITextView.init(frame: .zero)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.mixedTextColor = MixedColor.init(normal: .white, night: .black)
        textView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .green)
        return textView
    }()
    
    lazy var sendBtn : UIButton = {
        let sendBtn = UIButton.init(frame: .zero)
        sendBtn.setMixedTitleColor(MixedColor.init(normal: .white, night: .black), forState: .normal)
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.mixedBackgroundColor = MixedColor.init(normal: .black, night: .green)
        sendBtn.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        return sendBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat"
        //UI
        view.addSubview(textField)
        view.addSubview(sendBtn)
        view.addSubview(textView)
        //Constraint
        textField.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize.init(width: Double(SCREEN_WIDTH - 130.0), height: NAVIGATIONBAR_HEIGHT))
        }
        sendBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize.init(width: 100, height: NAVIGATIONBAR_HEIGHT))
        }
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(self.textField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10);
            make.size.equalTo(CGSize.init(width: SCREEN_WIDTH - 20, height: 200))
        }
        //启动服务器
        startServer()
    }
    
    //启动服务器
    func startServer() {
        //在后台线程中启动服务器
        DispatchQueue.global(qos: .background).async {
            do {
                //初始化服务器
                self.server = try SynchronousTCPServer(port: 8080)
                
                //在界面上显示启动信息
                DispatchQueue.main.async {
                    let hostname = self.server.address.hostname
                    let address = self.server.address.addressFamily
                    let port = self.server.address.port
                    self.textView.text = "服务器启动，监听："
                        + "\"\(hostname)\" (\(address)) \(port)\n"
                }
                
                //接收并处理客户端连接
                try self.server.startWithHandler { (client) in
                    self.handleClient(client: client)
                }
            } catch {
                print("Error \(error)")
            }
        }
    }
    
    //处理连接的客户端
    func handleClient(client:TCPClient){
        do {
            while true{
                //获取客户端发送过来的消息：[UInt8]类型
                let data = try client.receiveAll()
                
                //将接收到的消息转成String类型
                let str = try data.toString()
                //将这个String消息显示到界面上
                DispatchQueue.main.async {
                    self.textView.text = self.textView.text + "服务端接收到消息: \(str)\n"
                }
                
                //将接收到的消息又发回客户端
                try client.send(bytes: data)
                
                //try client.close() //关闭与客户端链接
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    //发送消息
    func sendMessage(_ sender: Any) {
        do {
            let message = self.textField.text
            if message != nil && message != "" {
                try client?.send(bytes: message!.toBytes())
                let str = try client!.receiveAll().toString()
                //将服务端返回的消息显示在界面上
                self.textView.text = self.textView.text + "客户端接收到反馈: \(str)\n"
                //try client.close() //关闭客户端与服务端链接
                
                //清空输入框
                self.textField.text = ""
            }
        } catch {
            print("Error \(error)")
        }
    }
}
