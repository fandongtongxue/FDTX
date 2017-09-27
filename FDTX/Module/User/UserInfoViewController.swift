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
        title = "用户信息"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let data = UIImagePNGRepresentation(UIImage.init(named: "uc_btn_setting")!)!
        BaseNetwoking.manager.UPLOAD(url: "userChangeUserIcon", parameters: ["uid":AppTool.shared.uid()], data:[data], success: { (result) in
            log.info(result)
        }) { (error) in
            //do nothing
        }
    }
}
