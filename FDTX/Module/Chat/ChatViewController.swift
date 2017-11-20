//
//  ChatViewController.swift
//  FDTX
//
//  Created by 范东 on 2017/11/14.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class ChatViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        navigationItem.title = "Chat Selected"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let chatDetailVC = ChatDetailViewController()
        chatDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatDetailVC, animated: true)
    }
}
