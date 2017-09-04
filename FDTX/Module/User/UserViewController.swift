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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.perform(#selector(toLoginVC), with: nil, afterDelay: 1, inModes: [.defaultRunLoopMode])
    }
    
    func toLoginVC() {
        let loginVC = LoginViewController()
        loginVC.hidesBottomBarWhenPushed = true
        let loginNav = RootNavigationController.init(rootViewController: loginVC)
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(loginNav, animated: true, completion: nil)
    }
}
