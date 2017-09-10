//
//  UserDefault.swift
//  FDTX
//
//  Created by fandong on 2017/9/10.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation

private let UserDefaultShared = UserDefault()

class UserDefault {
    
    class var shared : UserDefault {
        return UserDefaultShared
    }
}

extension UserDefault {
    
}
