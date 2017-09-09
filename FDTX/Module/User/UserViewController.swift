//
//  UserViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/23.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class UserViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.initSubview()
//        QiniuTool.shared.uploadImage(image: UIImage.init(named: "nav_btn_back_hl")!, key: "11")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.requestData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let openSourceVC = OpenSourceViewController()
        openSourceVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(openSourceVC, animated: true)
    }
    
    func initSubview() {
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    func requestData() {
        if AppTool.shared.isLogin() {
            BaseNetwoking.manager.GET(url: "userInfo", parameters: ["uid":AppTool.shared.uid], success: { (result) in
                let dataDict = result["data"] as! NSDictionary
                let userInfo = dataDict["userInfo"] as! NSArray
                let userInfoDict = userInfo.firstObject
                let model = UserInfoModel.deserialize(from: userInfoDict as? NSDictionary)
                
                let realm = try! Realm()
                let items = realm.objects(UserInfoModel.self)
                if items.count > 0 {
                    log.info(items)
                }
                try! realm.write {
                    realm.add(model!)
                }
                log.info(realm.configuration.fileURL)
                
                self.headerView.setModel(model: model!)
            }) { (error) in
                
            }
        }
    }
    
    lazy var headerView : UserHeaderView = {
        let headerView = UserHeaderView.init(frame: .zero)
        return headerView
    }()
}
