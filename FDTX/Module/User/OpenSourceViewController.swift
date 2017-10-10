//
//  OpenSourceViewController.swift
//  FDTX
//
//  Created by fandong on 2017/9/7.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import NightNight
import SwiftWebVC

let OpenSourceViewControllerCellId = "OpenSourceViewControllerCellId"

class OpenSourceViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        self.title = "Open Source"
        self.initSubview()
        self.requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func initSubview() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func requestData() {
        let path = Bundle.main.path(forResource: "openSource", ofType: "json")
        let url = URL.init(fileURLWithPath: path!)
        do{
            let data = try! Data.init(contentsOf: url)
            let jsonDic = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let dataDict = jsonDic["data"] as! NSDictionary
            let openSourceArray = dataDict["openSource"] as! NSArray
            for dict in openSourceArray {
                let model = OpenSourceModel.deserialize(from: (dict as! NSDictionary))
                self.dataArray.add(model!)
            }
            self.tableView.reloadData()
        }catch{
            //do nothing
        }
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OpenSourceViewControllerCellId)
        let model = self.dataArray.object(at: indexPath.row) as! OpenSourceModel
        cell?.selectionStyle = .none
        cell?.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        cell?.textLabel?.mixedTextColor = MixedColor.init(normal: .white, night: .black)
        cell?.textLabel?.text = model.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray.object(at: indexPath.row) as! OpenSourceModel
        let webVC = SwiftWebVC(urlString: model.url)
        webVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: OpenSourceViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    lazy var dataArray : NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
}
