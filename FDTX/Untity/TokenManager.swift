//
//  TokenManager.swift
//  FDTX
//
//  Created by 范东 on 2017/11/29.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation

private let defaultManager = TokenManager()

class TokenManager {
    
    class var manager : TokenManager {
        return defaultManager
    }
}

extension TokenManager {
    func getUploadToken(success : @escaping (_ response : String)->(), failure : @escaping (_ error : Error)->()) {
        //do nothing
        BaseNetwoking.manager.GET(url: TOKEN_URL, parameters: ["uuid":UUID], success: { (response) in
            if response["status"] as! NSNumber == NSNumber.init(value: 1){
                let data = response["data"] as! NSDictionary
                let token = data["token"] as! String
                success(token)
            }
        }) { (error) in
            log.error("error:\(error)")
            failure(error)
        }
    }
}
