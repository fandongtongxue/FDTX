//
//  UserInfoViewController.swift
//  FDTX
//
//  Created by fandong on 2017/9/8.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit

let UserInfoViewControllerCellId = "UserInfoViewControllerCellId"

class UserInfoViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.initSubview()
    }
    
    func initSubview() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoViewControllerCellId)
//        switch indexPath.row {
//        case 0:
//            cell
//        case 1:
//            
//        default:
//            <#code#>
//        }
//    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: UserInfoViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        return tableView
    }()
}
