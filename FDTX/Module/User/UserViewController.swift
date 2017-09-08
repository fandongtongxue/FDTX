//
//  UserViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/23.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit

class UserViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.initSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.requestData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let openSourceVC = OpenSourceViewController()
        openSourceVC.hidesBottomBarWhenPushed = true
        let openSourceNav = RootNavigationController.init(rootViewController: openSourceVC)
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(openSourceNav, animated: true, completion: nil)
    }
    
    func initSubview() {
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    func requestData() {
        BaseNetwoking.manager.GET(url: "userInfo", parameters: ["uid":AppTool.shared.uid], success: { (result) in
            let userInfo = result["data"]?["userInfo"] as! NSArray
            let userInfoDict = userInfo.firstObject
            let model = UserInfoModel.deserialize(from: userInfoDict as? NSDictionary)
            self.headerView.setModel(model: model!)
        }) { (error) in
            
        }
    }
    
    func toLoginVC() {
        let loginVC = LoginViewController()
        loginVC.hidesBottomBarWhenPushed = true
        let loginNav = RootNavigationController.init(rootViewController: loginVC)
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(loginNav, animated: true, completion: nil)
    }
    
    lazy var headerView : UserHeaderView = {
        let headerView = UserHeaderView.init(frame: .zero)
        return headerView
    }()
}
