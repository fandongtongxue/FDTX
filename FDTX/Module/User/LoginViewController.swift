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
import KeychainAccess
import NightNight

class LoginViewController: BaseViewController {
    var itemsGroupedByService: [String: [[String: Any]]]?
    //Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.title = "Sign In"
        self.initSubviews()
        self.reloadData()
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
            //KeyChain
            let keychain: Keychain
            keychain = Keychain(service: "fandongtongxue")
            keychain[self.userNameTextField.text!] = self.passWordTextField.text!
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
        userNameTextField.mixedTextColor = MixedColor.init(normal: .lightGray, night: .white)
        userNameTextField.keyboardType = .default
        userNameTextField.placeholder = "UserName"
        return userNameTextField
    }()
    
    lazy var passWordTextField : UITextField = {
        let passWordTextField = UITextField()
        passWordTextField.keyboardType = .default
        passWordTextField.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        passWordTextField.mixedTextColor = MixedColor.init(normal: .lightGray, night: .white)
        passWordTextField.placeholder = "PassWord"
        passWordTextField.isSecureTextEntry = true
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
        registerBtn.setMixedTitleColor(MixedColor.init(normal: .lightGray, night: .white), forState: .normal)
        registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        return registerBtn
    }()
    
    func reloadData() {
        let items = Keychain.allItems(.genericPassword)
        itemsGroupedByService = groupBy(items) { item -> String in
            if let service = item["service"] as? String {
                return service
            }
            return ""
        }
        //Read KeyChain
        let services = Array(itemsGroupedByService!.keys)
        if services.count > 0 {
            let service = services.first
            
            let allItems = Keychain(service: service!).allItems()
            let item = allItems.first
            
            self.userNameTextField.text = item?["key"] as? String
            self.passWordTextField.text = item?["value"] as? String
        }
    }

}

private func groupBy<C: Collection, K: Hashable>(_ xs: C, key: (C.Iterator.Element) -> K) -> [K:[C.Iterator.Element]] {
    var gs: [K:[C.Iterator.Element]] = [:]
    for x in xs {
        let k = key(x)
        var ys = gs[k] ?? []
        ys.append(x)
        gs.updateValue(ys, forKey: k)
    }
    return gs
}
