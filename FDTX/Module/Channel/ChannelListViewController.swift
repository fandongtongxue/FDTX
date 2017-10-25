//
//  ChannelList.swift
//  FDTX
//
//  Created by 范东 on 2017/10/21.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import BMPlayer

let ChannelListViewControllerCellId = "ChannelListViewControllerCellId"

class ChannelListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    let player = BMPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title = "Channel Selected"
        
        view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(0)
            make.left.right.equalTo(self.view)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        //hidden the back button
        player.controlView.backButton.isHidden = true
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view).offset(SCREEN_WIDTH * 9 / 16)
        }
        tableView.addSubview(refreshControl)
        requestData()
    }
    
    func setVideo(videoUrl : URL, videoTitle : String) {
        let asset = BMPlayerResource(url: videoUrl,
                                     name: videoTitle)
        player.setVideo(resource: asset)
    }
    
    func requestData() {
        if !refreshControl.isRefreshing {
            let size = CGSize.init(width: 30, height: 30)
            startAnimating(size, message: "Loading", messageFont: UIFont.systemFont(ofSize: 15), type: .lineScalePulseOut, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: UIColor.black, textColor: UIColor.white)
        }
        BaseNetwoking.manager.GET(url: "channelList", parameters: ["":""], success: { (result) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            self.dataArray.removeAllObjects()
            let dataDict = result["data"] as! NSDictionary
            let dataArray = dataDict["channelList"] as! NSArray
            for dict in dataArray {
                let model = ChannelModel.deserialize(from: (dict as! NSDictionary))
                self.dataArray.add(model!)
            }
            let model = self.dataArray.lastObject as! ChannelModel
            self.setVideo(videoUrl: URL.init(string: model.channelUrl)!, videoTitle: model.channelName)
            self.tableView.reloadData()
        }) { (error) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelListViewControllerCellId) as! UITableViewCell
        let model = self.dataArray.object(at: indexPath.row) as! ChannelModel
        cell.textLabel?.text = model.channelName
        cell.selectionStyle = .none
        cell.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        cell.textLabel?.mixedTextColor = MixedColor.init(normal: .lightGray, night: .black)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray.object(at: indexPath.row) as! ChannelModel
        self.setVideo(videoUrl: URL.init(string: model.channelUrl)!, videoTitle: model.channelName)
    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: ChannelListViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl.init()
        refreshControl.mixedTintColor = MixedColor.init(normal: .white, night: .black)
        refreshControl.addTarget(self, action: #selector(requestData), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    lazy var dataArray : NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
}
