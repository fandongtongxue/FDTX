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

class UserInfoViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title = "UserInfo"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func updateUserIcon(imageData:Data) {
        BaseNetwoking.manager.UPLOAD(url: "userChangeUserIcon", parameters: ["uid":AppTool.shared.uid()], data:[imageData], success: { (result) in
            log.info(result)
        }) { (error) in
            //do nothing
        }
    }
}
