//
//  LoginViewController.swift
//  FDTX
//
//  Created by fandong on 2017/9/4.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: BaseViewController {
    //Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.dismiss(animated: true, completion: nil)
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
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(44)
        }
        
        self.passWordTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.userNameTextField.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        self.loginBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.passWordTextField.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        
        self.registerBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.loginBtn.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
    }
    
    //Action
    func login() {
        //Loading
        let size = CGSize.init(width: 30, height: 30)
        startAnimating(size, message: "Logining", messageFont: UIFont.systemFont(ofSize: 15), type: .lineScalePulseOut, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: UIColor.black, textColor: UIColor.white)
        
        BaseNetwoking.manager.GET(url: "userLogin", parameters: ["userName":self.userNameTextField.text!,"passWord":self.passWordTextField.text!], success: { (result) in
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//                NVActivityIndicatorPresenter.setMessage(result["msg"])
//            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.stopAnimating()
            }
            log.info(result)
        }) { (error) in
            //do nothing
            self.stopAnimating()
        }
    }
    
    func register() {
        //Loading
        let size = CGSize.init(width: 30, height: 30)
        startAnimating(size, message: "Registering", messageFont: UIFont.systemFont(ofSize: 15), type: .lineScalePulseOut, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: UIColor.black, textColor: UIColor.white)
        
        BaseNetwoking.manager.GET(url: "userRegister", parameters: ["userName":self.userNameTextField.text!,"passWord":self.passWordTextField.text!], success: { (result) in
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//                NVActivityIndicatorPresenter.setMessage(result["msg"])
//            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.stopAnimating()
            }
            log.info(result)
        }) { (error) in
            //do nothing
            self.stopAnimating()
        }
    }
    //Lazy Load
    lazy var backView : UIImageView = {
       let backImageView = UIImageView.init(frame: .zero)
//       backImageView.image = UIImage.init(named: "")
       backImageView.backgroundColor = .cyan
       return backImageView
    }()
    
    lazy var userNameTextField : UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.keyboardType = .alphabet
        userNameTextField.placeholder = "Input UserName"
        return userNameTextField
    }()
    
    lazy var passWordTextField : UITextField = {
        let passWordTextField = UITextField()
        passWordTextField.keyboardType = .alphabet
        passWordTextField.placeholder = "Input PassWord"
        return passWordTextField
    }()
    
    lazy var loginBtn : UIButton = {
        let loginBtn = UIButton.init(frame: .zero)
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.backgroundColor = .black
        loginBtn.layer.cornerRadius = 22
        loginBtn.clipsToBounds = true
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return loginBtn
    }()
    
    lazy var registerBtn : UIButton = {
        let registerBtn = UIButton.init(frame: .zero)
        registerBtn.setTitle("Register", for: .normal)
        registerBtn.setTitleColor(.white, for: .normal)
        registerBtn.backgroundColor = .black
        registerBtn.layer.cornerRadius = 22
        registerBtn.clipsToBounds = true
        registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        return registerBtn
    }()
    
}
