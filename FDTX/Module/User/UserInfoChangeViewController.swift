//
//  UserInfoChangeViewController.swift
//  FDTX
//
//  Created by 范东 on 2017/11/30.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import PKHUD

class UserInfoChangeViewController: BaseViewController {
    
    public enum UserInfoChangeViewControllerType{
        case nickName
        case introduce
    }
    
    var vcType : UserInfoChangeViewControllerType
    var params : [String : String]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        vcType = .nickName
        params = ["uid":AppTool.shared.uid(),
                  "icon":AppTool.shared.icon(),
                  "nickName":AppTool.shared.nickName(),
                  "introduce":AppTool.shared.introduce()]
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title  = "Change Your UserInfo"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneBtnAction))
    }
    
    @objc func doneBtnAction() {
        view.endEditing(true)
        if vcType == .nickName {
            if textField.text?.count == 0{
                HUD.flash(.label("Not Input NickName"), delay: HUD_DELAY_TIME)
                return
            }
            params = ["uid":AppTool.shared.uid(),
                      "icon":AppTool.shared.icon(),
                      "nickName":textField.text!,
                      "introduce":AppTool.shared.introduce()]
        }else if vcType == .introduce{
            if textView.text?.count == 0{
                HUD.flash(.label("Not Input Introduce"), delay: HUD_DELAY_TIME)
                return
            }
            params = ["uid":AppTool.shared.uid(),
                      "icon":AppTool.shared.icon(),
                      "nickName":AppTool.shared.nickName(),
                      "introduce":textView.text]
        }
        BaseNetwoking.manager.POST(url: "userChangeUserInfo", parameters:params , success: { (response) in
            if self.vcType == .nickName{
                UserDefault.shared.setObject(object: self.textField.text!, forKey: USER_DEFAULT_KEY_NICKNAME)
            }
            if self.vcType == .introduce{
                UserDefault.shared.setObject(object: self.textView.text, forKey: USER_DEFAULT_KEY_INTRODUCE)
            }
            HUD.flash(.label("Update UserInfo Success"), delay: HUD_DELAY_TIME)
            self.perform(#selector(self.back), with: nil, afterDelay: HUD_DELAY_TIME)
        }, failure: { (error) in
            HUD.flash(.label(String.init(format: "%@", error as CVarArg)), delay: HUD_DELAY_TIME)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func setType(type:UserInfoChangeViewControllerType){
        vcType = type
        switch type {
        case .nickName:
            view.addSubview(textField)
            textField.snp.makeConstraints({ (make) in
                make.left.top.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(44)
            })
            textField.text = AppTool.shared.nickName()
            textField.becomeFirstResponder()
            break
        case .introduce:
            view.addSubview(textView)
            textView.snp.makeConstraints({ (make) in
                make.left.top.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.height.equalTo(132)
            })
            textView.text = AppTool.shared.introduce()
            textView.becomeFirstResponder()
            break
        default:
            //do nothing
            break
        }
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField.init(frame: .zero)
        textField.placeholder = "Please Input Your NickName"
        return textField
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView.init(frame: .zero)
        return textView
    }()
    
}
