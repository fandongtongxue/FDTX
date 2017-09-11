//
//  LoginViewController.swift
//  FDTX
//
//  Created by fandong on 2017/9/4.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

class LoginViewController: BaseViewController {
    //Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.initSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    //Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    //UI
    func initSubviews() {
        self.view.addSubview(self.backView)
        self.view.addSubview(self.userNameTextField)
        self.view.addSubview(self.passWordTextField)
        self.view.addSubview(self.loginBtn)
        self.view.addSubview(self.registerBtn)
        
        self.backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.userNameTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(STATUSBAR_HEIGHT)
            make.right.equalToSuperview().offset(-STATUSBAR_HEIGHT)
            make.top.equalToSuperview().offset(STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT)
            make.height.equalTo(NAVIGATIONBAR_HEIGHT)
        }
        
        self.passWordTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(STATUSBAR_HEIGHT)
            make.right.equalToSuperview().offset(-STATUSBAR_HEIGHT)
            make.top.equalTo(self.userNameTextField.snp.bottom).offset(20)
            make.height.equalTo(NAVIGATIONBAR_HEIGHT)
        }
        
        self.loginBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(STATUSBAR_HEIGHT)
            make.right.equalToSuperview().offset(-STATUSBAR_HEIGHT)
            make.top.equalTo(self.passWordTextField.snp.bottom).offset(20)
            make.height.equalTo(NAVIGATIONBAR_HEIGHT)
        }
        
        self.registerBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(STATUSBAR_HEIGHT)
            make.right.equalToSuperview().offset(-STATUSBAR_HEIGHT)
            make.top.equalTo(self.loginBtn.snp.bottom).offset(20)
            make.height.equalTo(STATUSBAR_HEIGHT)
        }
    }
    
    //Action
    func login() {
        self.view.endEditing(true)
        //Loading
        let size = CGSize.init(width: 30, height: 30)
        startAnimating(size, message: "Sign Ining", messageFont: UIFont.systemFont(ofSize: 15), type: .lineScalePulseOut, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: UIColor.black, textColor: UIColor.white)
        
        BaseNetwoking.manager.POST(url: "userLogin", parameters: ["userName":self.userNameTextField.text!,"passWord":self.passWordTextField.text!], success: { (result) in
            self.stopAnimating()
            HUD.flash(.label("Sign In Success"), delay: HUD_DELAY_TIME)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + HUD_DELAY_TIME) {
                self.dismiss(animated: true, completion: nil)
            }
            //标记登录成功
            UserDefault.shared.setObject(object: "1", forKey: USER_DEFAULT_KEY_ISLOGIN)
            let uid = result["data"]?["uid"] as! String
            UserDefault.shared.setObject(object: uid, forKey: USER_DEFAULT_KEY_UID)
            
        }) { (error) in
            self.stopAnimating()
            HUD.flash(.label(error.localizedDescription), delay: HUD_DELAY_TIME)
        }
    }
    
    func register() {
        self.view.endEditing(true)
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    //Lazy Load
    lazy var backView : UIImageView = {
       let backImageView = UIImageView.init(frame: .zero)
//       backImageView.image = UIImage.init(named: "")
       backImageView.backgroundColor = .black
       return backImageView
    }()
    
    lazy var userNameTextField : UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        userNameTextField.textColor = .white
        userNameTextField.keyboardType = .default
        userNameTextField.placeholder = "UserName"
        return userNameTextField
    }()
    
    lazy var passWordTextField : UITextField = {
        let passWordTextField = UITextField()
        passWordTextField.keyboardType = .default
        passWordTextField.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        passWordTextField.textColor = .white
        passWordTextField.placeholder = "PassWord"
        return passWordTextField
    }()
    
    lazy var loginBtn : UIButton = {
        let loginBtn = UIButton.init(frame: .zero)
        loginBtn.setTitle("Sign In", for: .normal)
        loginBtn.setTitleColor(.black, for: .normal)
        loginBtn.backgroundColor = .white
        loginBtn.layer.cornerRadius = CGFloat(NAVIGATIONBAR_HEIGHT / 2)
        loginBtn.clipsToBounds = true
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return loginBtn
    }()
    
    lazy var registerBtn : UIButton = {
        let registerBtn = UIButton.init(frame: .zero)
        registerBtn.setTitle("Sign Up", for: .normal)
        registerBtn.setTitleColor(.white, for: .normal)
        registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        return registerBtn
    }()

}
