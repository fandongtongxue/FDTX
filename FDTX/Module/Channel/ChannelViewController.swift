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

let ChannelListViewControllerCellId = "ChannelListViewControllerCellId"

class ChannelViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        navigationItem.title  = "Channel Selected"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.addSubview(refreshControl)
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func requestData() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelListViewControllerCellId) as! ChannelCell
        let model = self.dataArray.object(at: indexPath.row) as! ChannelModel
        cell.setModel(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray.object(at: indexPath.row) as! ChannelModel
        let vc = VideoViewController.init(nibName: nil, bundle: nil)
        vc.channelModel = model
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChannelCell.classForCoder(), forCellReuseIdentifier: ChannelListViewControllerCellId)
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
