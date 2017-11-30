//
//  StatusPublishViewController.swift
//  FDTX
//
//  Created by fandong on 2017/11/30.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class StatusPublishViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        initSubviews()
    }
    
    func initSubviews() {
        view.addSubview(dismissBtn)
        dismissBtn.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.left.equalToSuperview().offset(20)
            if UIDevice.current.isiPhoneX(){
                make.top.equalToSuperview().offset(50)
            }else{
                make.top.equalToSuperview().offset(30)
            }
        }
        
        view.addSubview(publishBtn)
        publishBtn.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            if UIDevice.current.isiPhoneX(){
                make.top.equalToSuperview().offset(50)
            }else{
                make.top.equalToSuperview().offset(30)
            }
        }
    }
    
    @objc func dismissBtnAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func publishBtnAction(){
        
    }

    lazy var dismissBtn : UIButton = {
        let dismissBtn = UIButton.init(frame: .zero)
        dismissBtn.setImage(UIImage.init(named: "btn_dismiss"), for: .normal)
        dismissBtn.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return dismissBtn
    }()
    
    lazy var publishBtn : UIButton = {
        let publishBtn = UIButton.init(frame: .zero)
        publishBtn.setImage(UIImage.init(named: "btn_status_publish"), for: .normal)
        publishBtn.addTarget(self, action: #selector(publishBtnAction), for: .touchUpInside)
        return publishBtn
    }()
    
}
