//
//  WordPressViewController.swift
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

let WordPressViewControllerCellId = "WordPressViewControllerCellId"
let WORD_PRESS_BLOG_ARTICLES_URL = "http://video.fandong.me/jsonapi/get_posts/?count=1000"

class WordPressViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title = "video.fandong.me"
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(WORD_PRESS_BLOG_ARTICLES_URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            self.stopAnimating()
            switch response.result{
            case .success:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.dataArray.removeAllObjects()
                if let result = response.result.value as? NSDictionary{
                    let array = result["posts"] as! NSArray
                    self.dataArray.removeAllObjects()
                    for dict in array{
                        let model = WordPressArticleModel.deserialize(from: dict as? NSDictionary)
                        self.dataArray.add(model!)
                    }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case.failure(let error):
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                log.error(error)
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WordPressViewControllerCellId) as! UITableViewCell
        let model = dataArray.object(at: indexPath.row) as! WordPressArticleModel
        cell.selectionStyle = .none
        cell.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        cell.textLabel?.mixedTextColor = MixedColor.init(normal: .white, night: .black)
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.text = model.title
        cell.detailTextLabel?.text = model.modified
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray.object(at: indexPath.row) as! WordPressArticleModel
        let webVC = WebViewController.init(nibName: nil, bundle: nil)
        webVC.HTMLString = model.content
        webVC.url = model.url
        webVC.hidesBottomBarWhenPushed = true
        webVC.isArticle = true
        webVC.post_id = model.id
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: WordPressViewControllerCellId)
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
