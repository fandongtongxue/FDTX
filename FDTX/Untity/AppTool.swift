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
    
    func nickName() -> String {
        if AppTool.shared.isLogin() {
            let nickName = UserDefault.shared.objectFor(key: USER_DEFAULT_KEY_NICKNAME)
            return nickName
        }
        return ""
    }
    
    func introduce() -> String {
        if AppTool.shared.isLogin() {
            let introduce = UserDefault.shared.objectFor(key: USER_DEFAULT_KEY_INTRODUCE)
            return introduce
        }
        return ""
    }
    
    func icon() -> String {
        if AppTool.shared.isLogin() {
            let icon = UserDefault.shared.objectFor(key: USER_DEFAULT_KEY_ICON)
            return icon
        }
        return ""
    }
    
    func translateDateToString(originDate:Date) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let dateString = formatter.string(from: originDate)
        return dateString
    }
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
