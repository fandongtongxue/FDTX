//
//  UserDefault.swift
//  FDTX
//
//  Created by fandong on 2017/9/10.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation

private let UserDefaultShared = UserDefault()
let userDefaults = UserDefaults.standard

class UserDefault {
    
    class var shared : UserDefault {
        return UserDefaultShared
    }
}

extension UserDefault {
    func setObject(object:String, forKey:String) {
        userDefaults.set(object, forKey: forKey)
        userDefaults.synchronize()
    }
    
    func objectFor(key:String) -> String{
        let object = userDefaults.value(forKey: key) as! String
        return object
    }
}
