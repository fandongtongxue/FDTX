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
        self.view.backgroundColor = UIColor.black
        self.title = "Unsplash精选"
        self.view.addSubview(self.tableView)
        self.tableView.addSubview(self.refreshControl)
        self.refreshControl.beginRefreshing()
        self.requestFirstPageData()
    }
    
    func requestFirstPageData(){
        page = 1
        let firstUrl = UnsplashUrl + String.init(format: "%d", page)
        Alamofire.request(firstUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            switch response.result{
            case .success:
                self.dataArray.removeAllObjects()
                if let result = response.result.value{
                    let array = result as! NSArray
//                    let model = UnsplashPictureModel.mj_objectArray(withKeyValuesArray: array) as [AnyObject]
                    self.dataArray.removeAllObjects()
                    for dict in array{
                        let model = UnsplashPictureModel.deserialize(from: dict as? NSDictionary)
                        self.dataArray.add(model!)
                    }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case.failure(let error):
                log.error(error)
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnsplashViewControllerCellId) as! UnsplashViewCell
        let model = self.dataArray.object(at: indexPath.row) as! UnsplashPictureModel
        cell.setModel(model: model);
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArray.object(at: indexPath.row) as! UnsplashPictureModel
        let screenWidth = Float(SCREEN_WIDTH)
        return CGFloat((model.height as NSString).floatValue * screenWidth / (model.width as NSString).floatValue)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray.object(at: indexPath.row) as! UnsplashPictureModel
        log.info(model.urls.regular)
    }
    
    //懒加载
    lazy var dataArray : NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UnsplashViewCell.classForCoder(), forCellReuseIdentifier: UnsplashViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        return tableView
    }()
    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl.init()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(requestFirstPageData), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
