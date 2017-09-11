//
//  AppTool.swift
//  FDTX
//
//  Created by fandong on 2017/9/6.
//  Copyright © 2017年 fandong. All rights reserved.
//  通用工具类

import Foundation

private let AppToolShared = AppTool()

class AppTool {
    
    class var shared : AppTool {
        return AppToolShared
    }
}

extension AppTool {
    func isLogin() -> Bool {
        let isLogin = UserDefault.shared.objectFor(key: USER_DEFAULT_KEY_ISLOGIN) 
        if isLogin == "1" {
            return true
        }
        return false
    }
    
    func uid() -> String {
        if AppTool.shared.isLogin() {
            let uid = UserDefault.shared.objectFor(key: USER_DEFAULT_KEY_UID)
            return uid
        }
        return ""
    }
}
