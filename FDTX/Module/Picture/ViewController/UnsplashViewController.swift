//
//  UnsplashViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/19.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let UnsplashViewControllerCellId = "UnsplashViewControllerCellId"
let UnsplashUrl = "https://api.unsplash.com/photos/?client_id=522f34661134a2300e6d94d344a7ab6424e028a51b31353363b7a8cce11d73b6&per_page=30&page="

class UnsplashViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    var page : NSInteger = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Unsplash精选"
        self.view.addSubview(self.tableView)
        self.tableView.addSubview(self.refreshControl)
    }
    
    func requestFirstPageData(){
        page = 1
        let firstUrl = UnsplashUrl + String.init(format: "%d", page)
        BaseNetworking.init().get(url: firstUrl)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnsplashViewControllerCellId) as! UnsplashViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT
    }
    
    //懒加载
    lazy var dataArray : NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UnsplashViewCell.superclass(), forCellReuseIdentifier: UnsplashViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        return tableView
    }()
    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl.init()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(requestFirstPageData), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
