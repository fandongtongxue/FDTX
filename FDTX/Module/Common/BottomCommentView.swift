//
//  BottomCommentView.swift
//  FDTX
//
//  Created by fandong on 2017/9/28.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import Alamofire
import PKHUD

class BottomCommentView: UIView {
    
    var post_id = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor.init(normal: UIColor.init(hex: "007aff"), night: UIColor.init(hex: "007aff"))
        initSubviews()
    }
    
    func initSubviews() {
        addSubview(textField)
        addSubview(sendBtn)
        textField.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(UIDevice.current.isiPhoneX() ? -25 : -5)
            make.right.equalTo(sendBtn.snp.left).offset(-5)
        }
        sendBtn.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.size.equalTo(CGSize.init(width: TABBAR_HEIGHT, height: TABBAR_HEIGHT))
        }
    }
    
    func sendBtnAction(sender:UIButton) {
        sender.isEnabled = false
        
        log.info("Send:" + self.textField.text!)
        
        let content = self.textField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = WORDPRESS_URL+"respond/submit_comment?post_id=" + post_id + "&name=" + AppTool.shared.nickName() + "&email=" + "user@fandong.me" + "&content="
        
        let finalUrl = url + content!
        
        Alamofire.request(finalUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            switch response.result{
            case .success:
                if let result = response.result.value{
                    log.info("Comment Publish Success")
                    log.info(result)
                    HUD.flash(.label("Comment Success"), delay: HUD_DELAY_TIME)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + HUD_DELAY_TIME) {
                        self.viewController()?.dismiss(animated: true, completion: nil)
                        sender.isEnabled = true
                        self.textField.text = ""
                        self.textField.resignFirstResponder()
                    }
                }
            case.failure(let error):
                log.error(error)
                sender.isEnabled = true
                HUD.flash(.label(error.localizedDescription), delay: HUD_DELAY_TIME)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + HUD_DELAY_TIME) {
                    self.viewController()?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    lazy var textField : UITextField = {
        let textField = UITextField.init(frame: .zero)
        textField.placeholder = "Please Input Comments"
        textField.mixedBackgroundColor = MixedColor.init(normal: .white, night: .white)
        textField.mixedTextColor = MixedColor.init(normal: .black, night: .black)
        textField.font = UIFont.systemFont(ofSize: 15)
        return textField
    }()
    
    lazy var sendBtn : UIButton = {
        let sendBtn = UIButton.init(frame: .zero)
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sendBtn.titleLabel?.mixedTextColor = MixedColor.init(normal: .white, night: .white)
        sendBtn.addTarget(self, action: #selector(sendBtnAction(sender:)), for: .touchUpInside)
        return sendBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
