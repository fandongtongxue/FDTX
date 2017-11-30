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

class StatusViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        navigationItem.title = "Status Selected"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "btn_status_add"), style: .plain, target: self, action: #selector(addStatus))
    }
    
    @objc func addStatus(){
        let statusPublishVC = StatusPublishViewController()
        present(statusPublishVC, animated: true, completion: nil)
    }
    
}
