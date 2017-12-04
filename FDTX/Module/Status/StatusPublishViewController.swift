//
//  StatusPublishViewController.swift
//  FDTX
//
//  Created by 范东 on 2017/12/2.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import PKHUD
import TGPhotoPicker

class StatusPublishViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title = "Publish Status"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "common_btn_dismiss"), style: .plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "status_btn_publish"), style: .plain, target: self, action: #selector(publish))
        
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func publish() {
        let params = ["uid":AppTool.shared.uid(),
                      "imgUrls":"https://wx2.sinaimg.cn/mw690/686a3ea1gy1ff9175ftbjj22ds1sge81.jpg,https://wx3.sinaimg.cn/mw690/686a3ea1gy1ff917jo0wxj23402c0u0x.jpg",
                      "content":"和你们在一起很开心！",
                      "location":"北京市石景山区古城路小区"]
        BaseNetwoking.manager.POST(url: "statusPublish", parameters: params, success: { (response) in
            self.perform(#selector(self.back), with: nil, afterDelay: HUD_DELAY_TIME)
        }) { (error) in
            HUD.flash(.label(String.init(format: "%@", error as CVarArg)), delay: HUD_DELAY_TIME)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
