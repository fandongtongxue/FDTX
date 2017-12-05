//
//  StatusListViewController.swift
//  FDTX
//
//  Created by fandong on 2017/11/17.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import PKHUD

let StatusViewControllerCellId = "StatusViewControllerCellId"

class StatusViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        navigationItem.title = "Status Selected"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "status_btn_add"), style: .plain, target: self, action: #selector(addStatus))
        initSubview()
        requestData()
    }
    
    @objc func addStatus(){
        let statusPublishVC = StatusPublishViewController.init(nibName: nil, bundle: nil)
        let statusPublishNav = RootNavigationController.init(rootViewController: statusPublishVC)
        present(statusPublishNav, animated: true, completion: nil)
    }
    
    @objc func requestData() {
        if !refreshControl.isRefreshing {
            let size = CGSize.init(width: 30, height: 30)
            startAnimating(size, message: "Loading", messageFont: UIFont.systemFont(ofSize: 15), type: .lineScalePulseOut, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: UIColor.black, textColor: UIColor.white)
        }
        BaseNetwoking.manager.GET(url: "statusList", parameters: ["":""], success: { (result) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            self.dataArray.removeAllObjects()
            let dataDict = result["data"] as! NSDictionary
            let dataArray = dataDict["statusList"] as! NSArray
            for dict in dataArray {
                let model = StatusModel.deserialize(from: (dict as! NSDictionary))
                self.dataArray.add(model!)
            }
            self.tableView.reloadData()
        }) { (error) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            HUD.flash(.label(String.init(format: "%@", error as CVarArg)), delay: HUD_DELAY_TIME)
        }
    }
    
    func initSubview() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.addSubview(refreshControl)
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusViewControllerCellId) as! StatusCell
        configureCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.fd_heightForCell(withIdentifier: StatusViewControllerCellId, cacheBy: indexPath) { (cell) in
            self.configureCell(cell: cell as! StatusCell, atIndexPath: indexPath)
        }
        return height
    }
    
    func configureCell(cell:StatusCell, atIndexPath:IndexPath) {
        cell.fd_enforceFrameLayout = false
        let model = self.dataArray.object(at: atIndexPath.row) as! StatusModel
        cell.setModel(model: model)
    }
    
    //UITableViewDelegate
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StatusCell.classForCoder(), forCellReuseIdentifier: StatusViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
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
