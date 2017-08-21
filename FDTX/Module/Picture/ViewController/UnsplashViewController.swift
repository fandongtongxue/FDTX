//
//  UnsplashViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/19.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit

class UnsplashViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let cellId = "UnsplashViewControllerCellId"
    var page : NSInteger = 1
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Unsplash精选"
    }
    
    //UITableView协议方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    //懒加载
    lazy var dataArray : NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        return tableView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
