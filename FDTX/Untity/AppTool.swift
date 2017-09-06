//
//  AppTool.swift
//  FDTX
//
//  Created by fandong on 2017/9/6.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation

private let AppToolShared = AppTool()

class AppTool {
    class var shared : AppTool {
        return AppToolShared
    }
}

extension AppTool {
    //是否登录
    func isLogin() -> Bool {
        return true
    }
}
