//
//  OpenSourceViewController.swift
//  FDTX
//
//  Created by fandong on 2017/9/7.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit

let OpenSourceViewControllerCellId = "OpenSourceViewControllerCellId"

class OpenSourceViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
        self.requestData()
    }
    
    func initSubview() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func requestData() {
        let path = Bundle.main.path(forResource: "openSource", ofType: "json")
        let data = NSData.init(contentsOfFile: path!)
        let result = try JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers)
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OpenSourceViewControllerCellId)
        cell?.textLabel?.text = ""
        return cell!
    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: OpenSourceViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        return tableView
    }()
}
