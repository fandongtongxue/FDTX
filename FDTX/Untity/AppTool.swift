//
//  AppTool.swift
//  FDTX
//
//  Created by fandong on 2017/9/6.
//  Copyright © 2017年 fandong. All rights reserved.
//  通用工具类

import Foundation
import Qiniu

private let AppToolShared = AppTool()

class AppTool {
    
    var uid : String!
    var isLogin : Bool!
    
    class var shared : AppTool {
        return AppToolShared
    }
}

extension AppTool {
    
}
