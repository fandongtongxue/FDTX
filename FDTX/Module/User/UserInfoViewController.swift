//
//  UserInfoViewController.swift
//  FDTX
//
//  Created by fandong on 2017/9/26.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import PKHUD

let UserInfoViewControllerCellId = "UserInfoViewControllerCellId"

class UserInfoViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title = "UserInfo"
        initSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tableView.reloadData()
    }
    
    func initSubview() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoViewControllerCellId) as! UserInfoCell
        switch indexPath.row {
        case 0:
            cell.setType(type: .icon)
            cell.setValue(value: AppTool.shared.icon())
            break
        case 1:
            cell.setType(type: .nickName)
            cell.setValue(value: AppTool.shared.nickName())
            break
        case 2:
            cell.setType(type: .introduce)
            cell.setValue(value: AppTool.shared.introduce())
            break
        default:
            //do nothing
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 80
        case 1:
            return 44
        case 2:
            return 44
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let alert = UIAlertController.init(title: "Select Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (alertAction) in
                let imagePicker = UIImagePickerController.init()
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction.init(title: "PhotoLibrary", style: .default, handler: { (alertAction) in
                let imagePicker = UIImagePickerController.init()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            break
        case 1:
            let userInfoChangeVC = UserInfoChangeViewController()
            userInfoChangeVC.setType(type: .nickName)
            navigationController?.pushViewController(userInfoChangeVC, animated: true)
            break
        case 2:
            let userInfoChangeVC = UserInfoChangeViewController()
            userInfoChangeVC.setType(type: .introduce)
            navigationController?.pushViewController(userInfoChangeVC, animated: true)
            break
        default:
            break
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        log.info(info)
        picker.dismiss(animated: true, completion: nil)
        let image = info["UIImagePickerControllerOriginalImage"]
        TokenManager.manager.getUploadToken(success: { (token) in
            let data = UIImageJPEGRepresentation(image as! UIImage, 0.25)
            let key = String.init(format: "USER_ICON_UID_%@_DATE_%@.jpg", AppTool.shared.uid(),Date.init(timeIntervalSinceNow: 0) as CVarArg)
            QiniuUploadManager.default().upload(data, key:key , token: token, successBlock: { (result) in
                log.info(result)
                let params = ["uid":AppTool.shared.uid(),
                              "icon":String.init(format: "%@%@", QINIU_URL,key),
                              "nickName":AppTool.shared.nickName(),
                              "introduce":AppTool.shared.introduce()]
                BaseNetwoking.manager.POST(url: "userChangeUserInfo", parameters:params , success: { (response) in
                    UserDefault.shared.setObject(object: String.init(format: "%@%@", QINIU_URL,key), forKey: USER_DEFAULT_KEY_ICON)
                    self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .fade)
                    HUD.flash(.label("Update UserIcon Success"), delay: HUD_DELAY_TIME)
                }, failure: { (error) in
                    HUD.flash(.label(String.init(format: "%@", error as CVarArg)), delay: HUD_DELAY_TIME)
                })
            }, fail: { (error) in
                log.error("error:\(String(describing: error))")
            }, progressBlock: { (progress) in
                log.info(progress)
            })
        }) { (error) in
            log.error("error:\(error)")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        log.info("You Clicked Cancel")
        picker.dismiss(animated: true, completion: nil)
    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserInfoCell.classForCoder(), forCellReuseIdentifier: UserInfoViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
}
