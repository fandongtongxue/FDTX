//
//  ChannelDetailViewController.swift
//  FDTX
//
//  Created by fandong on 2017/10/27.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import BMPlayer
import PKHUD

let VideoViewControllerCellId = "VideoViewControllerCellId"

class VideoViewController: BaseViewController,ChatInputDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var channelModel = ChannelModel()
    var sendView = ChatInput()
    var chatInputOffset = 0.0
    
    
    fileprivate var bottomChatInputConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        //MARK: SendView
        view.addSubview(sendView)
        sendView.delegate = self
        sendView.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(UIDevice.current.isiPhoneX() ? (-24-chatInputOffset) : -chatInputOffset)
            make.left.right.equalToSuperview()
        }
        listenForKeyboardChanges()
        //MARK: Player
        let player = BMPlayer()
        view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        //MARK: Back button event
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true { return }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        let res0 = BMPlayerResourceDefinition(url: URL(string: channelModel.channelUrl)!,
                                              definition: "HD")
        
        let asset = BMPlayerResource(name: channelModel.channelName,
                                     definitions: [res0])
        player.setVideo(resource: asset)
        requestData()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.sendView.snp.top)
            make.top.equalTo(player.snp.bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardObservers()
    }
    
    fileprivate func listenForKeyboardChanges() {
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self,
                                  selector: #selector(keyboardWillChangeFrame(_:)),
                                  name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                  object: nil)
    }
    
    fileprivate func unregisterKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillChangeFrame(_ note: Notification) {
        let keyboardAnimationDetail = note.userInfo!
        let duration = keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        var keyboardFrame = (keyboardAnimationDetail[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if let window = self.view.window {
            keyboardFrame = window.convert(keyboardFrame, to: self.view)
        }
        let animationCurve = keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        self.view.layoutIfNeeded()
        chatInputOffset = Double(-((self.view.bounds.height - self.bottomLayoutGuide.length) - keyboardFrame.minY))
        if chatInputOffset > 0 {
            chatInputOffset = 0
        }
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: animationCurve), animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: {(finished) -> () in
            
        })
    }
    //MARK: ChatInPutDelegate
    func chatInputDidResize(_ chatInput: ChatInput) {
        //do nothing
    }
    func chatInput(_ chatInput: ChatInput, didSendMessage message: String) {
        if !AppTool.shared.isLogin() {
            let loginVC = LoginViewController()
            loginVC.hidesBottomBarWhenPushed = true
            let loginNav = RootNavigationController.init(rootViewController: loginVC)
            present(loginNav, animated: true, completion: nil)
            return
        }
        //Comment
        let param = ["uid":AppTool.shared.uid(),
                         "objectId":channelModel.channelId,
                         "type":"0",
                         "comment":message]
        BaseNetwoking.manager.POST(url: "comment", parameters: param as! [String : String], success: { (result) in
            HUD.flash(.label("Comment Success"), delay: HUD_DELAY_TIME)
            self.requestData()
        }) { (error) in
            HUD.flash(.label(error.localizedDescription), delay: HUD_DELAY_TIME)
        }
    }
    
    //MARK: CommentList
    func requestData() {
        let param = ["objectId":channelModel.channelId,"type":"0"]
        BaseNetwoking.manager.GET(url: "commentList", parameters:param as! [String:String] , success: { (result) in
            self.dataArray.removeAllObjects()
            let dataDict = result["data"] as! NSDictionary
            let dataArray = dataDict["commentList"] as! NSArray
            for dict in dataArray {
                let model = ChannelCommentModel.deserialize(from: (dict as! NSDictionary))
                self.dataArray.add(model!)
            }
            self.tableView.reloadData()
        }) { (error) in
            HUD.flash(.label(error.localizedDescription), delay: HUD_DELAY_TIME)
        }
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoViewControllerCellId) as! ChannelCommentCell
        let model = self.dataArray.object(at: indexPath.row) as! ChannelCommentModel
        cell.setModel(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //do nothing
    }
    
    //MARK: Lazy Load
    lazy var dataArray : NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChannelCommentCell.classForCoder(), forCellReuseIdentifier: VideoViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .singleLine
        return tableView
    }()
}
