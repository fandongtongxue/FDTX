//
//  SettingViewController.swift
//  FDTX
//
//  Created by fandong on 2017/9/11.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import SwiftWebVC

let SettingViewControllerCellId = "SettingViewControllerCellId"

class SettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title = "Setting"
        view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(TABBAR_HEIGHT + (UIDevice.current.isiPhoneX() ? STATUSBAR_HEIGHT : 0))
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(logoutBtn.snp.top)
        }
        dataArray = NSMutableArray.init(array: [["Open Source","About","Version 1.0.0"]])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func logoutBtnAction() {
        let alertVC = UIAlertController.init(title: "Warning", message: "Are You Want To Sign Out ?", preferredStyle: .alert)
        let confirmAlertAction = UIAlertAction.init(title: "Sign Out", style: .default) { (alertAction) in
            UserDefault.shared.setObject(object: "0", forKey: USER_DEFAULT_KEY_ISLOGIN)
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(confirmAlertAction)
        alertVC.addAction(cancelAlertAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = dataArray.object(at: section) as! NSArray
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewControllerCellId)
            cell?.selectionStyle = .none
            cell?.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
            cell?.textLabel?.mixedTextColor = MixedColor.init(normal: .white, night: .black)
            let array = dataArray.object(at: indexPath.section) as! NSArray
            cell?.textLabel?.text = (array.object(at: indexPath.row) as! String)
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewControllerCellId)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let openSourceVC = OpenSourceViewController()
                openSourceVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(openSourceVC, animated: true)
                break
            case 1:
                let webVC = SwiftWebVC(urlString:SERVER_HOST + "about")
                webVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(webVC, animated: true)
                break
            case 2:
                break
            default:
                //do nothing
                break
            }
        default:
            //do nothing
            break
        }
    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: SettingViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    lazy var dataArray : NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
    
    lazy var logoutBtn : UIButton = {
        let logoutBtn = UIButton.init(frame: .zero)
        logoutBtn.setTitle("Sign Out", for: .normal)
        logoutBtn.setMixedTitleColor(MixedColor.init(normal: .white, night: .white), forState: .normal)
        logoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        logoutBtn.mixedBackgroundColor = MixedColor.init(normal: .red, night: .red)
        logoutBtn.addTarget(self, action: #selector(logoutBtnAction), for: .touchUpInside)
        logoutBtn.titleEdgeInsets = UIEdgeInsets.init(top: UIDevice.current.isiPhoneX() ? -10 : 0, left: 0, bottom: UIDevice.current.isiPhoneX() ? 10 : 0, right: 0)
        return logoutBtn
    }()
    
}

