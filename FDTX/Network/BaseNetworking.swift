//
//  BaseNetworking.swift
//  FDTX
//
//  Created by fandong on 2017/8/13.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import Alamofire

private let BaseNetworkingManager = BaseNetwoking()

class BaseNetwoking {
    class var manager : BaseNetwoking {
        return BaseNetworkingManager
    }
}

extension BaseNetwoking {
    //GET请求
    func GET(url: String, parameters : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failure : @escaping (_ error : Error)->()) {
        Alamofire.request(SERVER_HOST + url, method: .get, parameters: parameters)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let result = value as! [String : AnyObject]
                    if result["state"]?.int64Value == 1{
                        success(result)
                    }else{
                        let errorResult = NSError.init(domain: SERVER_HOST, code: result["state"] as! Int, userInfo: ["msg":result["msg"]!])
                        log.error("error:\(errorResult)")
                        failure(errorResult as Error)
                    }
                case .failure(let error):
                    log.error("error:\(error)")
                    failure(error)
            }
        }
    }
}
