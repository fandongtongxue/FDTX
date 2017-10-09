//
//  GitHubPageViewController.swift
//  FDTX
//
//  Created by fandong on 2017/9/19.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import Alamofire
import SwiftWebVC

let GitHubPageViewControllerCellId = "GitHubPageViewControllerCellId"
let GITHUB_PAGE_BLOG_ARTICLES_URL = "http://blog.fandong.me/getArticleList.json"

class GitHubPageViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title = "blog.fandong.me"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.addSubview(refreshControl)
        requestData()
    }
    
    func requestData() {
        if !refreshControl.isRefreshing {
            let size = CGSize.init(width: 30, height: 30)
            startAnimating(size, message: "Loading", messageFont: UIFont.systemFont(ofSize: 15), type: .lineScalePulseOut, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: UIColor.black, textColor: UIColor.white)
        }
        Alamofire.request(GITHUB_PAGE_BLOG_ARTICLES_URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            self.stopAnimating()
            switch response.result{
            case .success:
                self.dataArray.removeAllObjects()
                if let result = response.result.value{
                    let array = result as! NSArray
                    self.dataArray.removeAllObjects()
                    for dict in array{
                        let model = GitHubPageArticleModel.deserialize(from: dict as? NSDictionary)
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
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: GitHubPageViewControllerCellId) as! GitHubPageArticleCell
        let model = dataArray.object(at: indexPath.row) as! GitHubPageArticleModel
        cell.setModel(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray.object(at: indexPath.row) as! GitHubPageArticleModel
        let webVC = SwiftWebVC(urlString: model.url)
        webVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GitHubPageArticleCell.classForCoder(), forCellReuseIdentifier: GitHubPageViewControllerCellId)
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
