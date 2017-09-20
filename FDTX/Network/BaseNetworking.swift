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
    func upLoadImage(url : String, parameters: [String:String], data: [Data], name: [String], success : @escaping (_ response : [String : AnyObject])->(), failure : @escaping (_ error : Error)->()){
        
        let headers = ["content-type":"multipart/form-data"]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //多张图片
                let flag = parameters["flag"]
                let userId = parameters["userId"]
                
                multipartFormData.append((flag?.data(using: String.Encoding.utf8)!)!, withName: "flag")
                multipartFormData.append( (userId?.data(using: String.Encoding.utf8)!)!, withName: "userId")
                
                for i in 0..<data.count {
                    multipartFormData.append(data[i], withName: "appPhoto", fileName: name[i], mimeType: "image/png")
                }
        },
            to: url,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            log.info(value)
                            success(value)
                        }
                    }
                case .failure(let error):
                    log.error(error)
                    failure(error)
                }
        }
        )
    }
}
