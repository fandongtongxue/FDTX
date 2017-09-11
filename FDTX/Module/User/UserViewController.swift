//
//  UserViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/23.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class UserViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        self.title = "UserCenter"
        self.initSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.requestData()
    }
    
    func initSubview() {
        self.view.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        self.view.addSubview(self.settingBtn)
        self.settingBtn.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(30)
        }
        self.view.addSubview(self.nightModeSwitch)
        self.nightModeSwitch.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(30)
        }
    }
    
    func requestData() {
        if AppTool.shared.isLogin() {
            let parameters = ["uid":AppTool.shared.uid()]
            BaseNetwoking.manager.GET(url: "userInfo", parameters: parameters, success: { (result) in
                let dataDict = result["data"] as! NSDictionary
                let userInfo = dataDict["userInfo"] as! NSArray
                let userInfoDict = userInfo.firstObject
                let model = UserInfoModel.deserialize(from: userInfoDict as? NSDictionary)
                self.headerView.setModel(model: model!)
            }) { (error) in
                
            }
        }else{
            let loginVC = LoginViewController()
            loginVC.hidesBottomBarWhenPushed = true
            let loginNav = RootNavigationController.init(rootViewController: loginVC)
            present(loginNav, animated: true, completion: nil)
        }
    }
    
    func settingBtnAction() {
        let settingVC = SettingViewController()
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    func nightModeSwitch(sender:UISwitch) {
        if sender.isOn {
            //夜间模式打开
            NightNight.theme = .night
        }else{
            NightNight.theme = .normal
        }
    }
    lazy var headerView : UserHeaderView = {
        let headerView = UserHeaderView.init(frame: .zero)
        return headerView
    }()
    
    lazy var settingBtn : UIButton = {
        let settingBtn = UIButton.init(frame: .zero)
        settingBtn.setImage(UIImage.init(named: "uc_btn_setting"), for: .normal)
        settingBtn.addTarget(self, action: #selector(settingBtnAction), for: .touchUpInside)
        return settingBtn
    }()
    
    lazy var nightModeSwitch : UISwitch = {
        let nightModeSwitch = UISwitch.init(frame: .zero)
        nightModeSwitch.addTarget(self, action: #selector(nightModeSwitch(sender:)), for: .touchUpInside)
        nightModeSwitch.setOn(false, animated: true)
        return nightModeSwitch
    }()
}
