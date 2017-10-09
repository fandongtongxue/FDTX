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

class BottomCommentView: UIView {
    
    var post_id = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = MixedColor.init(normal: .black, night: .black)
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
    
    func sendBtnAction() {
        log.info("Send" + self.textField.text!)
        
        let parameters = ["post_id":post_id,"name":AppTool.shared.nickName(),"email":"user@fandong.me","content":self.textField.text!]
        
        Alamofire.request(WORDPRESS_URL+"respond/submit_comment/", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            switch response.result{
            case .success:
                if let result = response.result.value{
                    log.info(result)
                }
            case.failure(let error):
                log.error(error)
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
        sendBtn.addTarget(self, action: #selector(sendBtnAction), for: .touchUpInside)
        return sendBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
