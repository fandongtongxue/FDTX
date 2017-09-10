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
//        let realm = try! Realm()
//        let items = realm.objects(UserInfoModel.self)
//        if items.count > 0 {
//            return true
//        }
        return false
    }
    
    func uid() -> String {
//        if AppTool.shared.isLogin() {
//            let realm = try! Realm()
//            let items = realm.objects(UserInfoModel.self)
//            if items.count > 0 {
//                let userId = items[0].uid
//                return userId!
//            }
//        }
        return ""
    }
}
