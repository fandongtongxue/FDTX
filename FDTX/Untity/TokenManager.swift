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
        BaseNetwoking.manager.GET(url: "http://api.fandong.me/api/qiniucloudstorge/php-sdk-master/examples/upload_token.php", parameters: ["uuid":"9bd757fa5d3c40e482daa7fa2b2be1ed"], success: { (response) in
            if response["status"] as! NSNumber == NSNumber.init(value: 1){
                log.info(response)
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
