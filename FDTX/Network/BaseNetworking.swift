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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(finalUrl, method: .get, parameters: parameters, headers:nil)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let result = value as! [String : AnyObject]
                    if result["status"]?.int64Value == 1{
                        success(result)
                    }else{
                        let errorResult = NSError.init(domain: SERVER_HOST, code: result["status"] as! Int, userInfo: ["msg":result["msg"]!])
                        log.error("error:\(errorResult)")
                        failure(errorResult as Error)
                    }
                case .failure(let error):
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    log.error("error:\(error)")
                    failure(error)
            }
        }
    }
    //POST
    func POST(url : String, parameters : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failure : @escaping (_ error : Error)->()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(SERVER_HOST + url, method: .post, parameters: parameters, headers: nil)
            .responseJSON { (response) in
            switch response.result{
            case .success(let value):
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let result = value as! [String : AnyObject]
                if result["status"]?.int64Value == 1{
                    success(result)
                }else{
                    let errorResult = NSError.init(domain: SERVER_HOST, code: result["status"] as! Int, userInfo: ["msg":result["msg"]!])
                    log.error("error:\(errorResult)")
                    failure(errorResult as Error)
                }
            case .failure(let error):
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                log.error("error:\(error)")
                failure(error)
            }
            
        }
    }
    //UPLOAD
    func UPLOAD(url : String, parameters: [String : String], data : [Data], success : @escaping (_ response : [String : AnyObject])->(), failure : @escaping (_ error : Error)->()){
        let headers = ["content-type":"multipart/form-data"]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                let uid = parameters["uid"]
                multipartFormData.append( (uid?.data(using: String.Encoding.utf8)!)!, withName: "uid")
                for i in 0..<data.count {
                    multipartFormData.append(data[i], withName: "userIcon", fileName: "test", mimeType: "image/png")
                }
        },
            to: SERVER_HOST + url,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            success(value)
                        }
                    }
                case .failure(let encodingError):
                    failure(encodingError)
                    log.error("error:\(encodingError)")
                }
            }
        )
    }
}
