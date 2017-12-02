//
//  StatusListViewController.swift
//  FDTX
//
//  Created by fandong on 2017/11/17.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import PKHUD

class StatusViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        navigationItem.title = "Status Selected"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "status_btn_add"), style: .plain, target: self, action: #selector(addStatus))
        requestData()
    }
    
    @objc func addStatus(){
        let statusPublishVC = StatusPublishViewController.init(nibName: nil, bundle: nil)
        let statusPublishNav = RootNavigationController.init(rootViewController: statusPublishVC)
        present(statusPublishNav, animated: true, completion: nil)
    }
    
    func requestData() {
        BaseNetwoking.manager.GET(url: "statusList", parameters: ["":""], success: { (response) in
            log.info(response)
        }) { (error) in
            HUD.flash(.label(String.init(format: "%@", error as CVarArg)), delay: HUD_DELAY_TIME)
        }
    }
    
}
