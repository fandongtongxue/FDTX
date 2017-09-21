//
//  BaseNetworking.swift
//  FDTX
//
//  Created by fandong on 2017/8/13.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

private let BaseNetworkingManager = BaseNetwoking()

class BaseNetwoking {
    class var manager : BaseNetwoking {
        return BaseNetworkingManager
    }
}

extension BaseNetwoking {
    //GET请求
    func GET(url: String, parameters : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failure : @escaping (_ error : Error)->()) {
        var finalUrl = ""
        //如果来源于原有API
        if url.hasPrefix("http://") {
            finalUrl = url
        }else{
            finalUrl = SERVER_HOST + url
        }
        Alamofire.request(finalUrl, method: .get, parameters: parameters, headers:nil)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let result = value as! [String : AnyObject]
                    if result["status"]?.int64Value == 1{
                        success(result)
                    }else{
                        let errorResult = NSError.init(domain: SERVER_HOST, code: result["status"] as! Int, userInfo: ["msg":result["msg"]!])
                        log.error("error:\(errorResult)")
                        failure(errorResult as Error)
                    }
                case .failure(let error):
                    log.error("error:\(error)")
                    failure(error)
            }
        }
    }
    //POST
    func POST(url : String, parameters : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failure : @escaping (_ error : Error)->()) {
        Alamofire.request(SERVER_HOST + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let result = value as! [String : AnyObject]
                if result["status"]?.int64Value == 1{
                    success(result)
                }else{
                    let errorResult = NSError.init(domain: SERVER_HOST, code: result["status"] as! Int, userInfo: ["msg":result["msg"]!])
                    log.error("error:\(errorResult)")
                    failure(errorResult as Error)
                }
            case .failure(let error):
                log.error("error:\(error)")
                failure(error)
            }
            
        }
    }
    //上传图片
    func UPLOAD_IMAGE(url : String, parameters: [String:String], data: [Data], success : @escaping (_ response : [String : AnyObject])->(), failure : @escaping (_ error : Error)->()){
        Alamofire.upload(multipartFormData: { (<#MultipartFormData#>) in
            <#code#>
        }, to: <#T##URLConvertible#>) { (<#SessionManager.MultipartFormDataEncodingResult#>) in
            <#code#>
        }
    }
}
