//
//  QiniuTool.swift
//  FDTX
//
//  Created by fandong on 2017/9/8.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import Qiniu

let QINIU_GETTOKEN_URL = "http://api.fandong.me/api/qiniucloudstorge/php-sdk-master/examples/upload_token.php"

private let QiniuToolShared = QiniuTool()

class QiniuTool {
    
    class var shared : QiniuTool {
        return QiniuToolShared
    }
}

extension QiniuTool {
    func uploadImage(image:UIImage,key:String) {
        //获取上传Token
        BaseNetwoking.manager.GET(url: QINIU_GETTOKEN_URL, parameters: [:], success: { (result) in
            if result["status"]?.int64Value == 1{
                let token = result["data"]?["token"] as! String
                let config = QNConfiguration.build { (builder) in
                    //七牛华东区上传文件
                    builder?.setZone(QNZone.zone0())
                }
                let manager = QNUploadManager.init(configuration: config)
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                let uploadOption = QNUploadOption.init(mime: <#T##String!#>, progressHandler: { (<#String?#>, <#Float#>) in
                    <#code#>
                }, params: <#T##[AnyHashable : Any]!#>, checkCrc: <#T##Bool#>, cancellationSignal: <#T##QNUpCancellationSignal!##QNUpCancellationSignal!##() -> Bool#>)
                manager?.put(imageData, key: key, token: token, complete: { (<#QNResponseInfo?#>, <#String?#>, <#[AnyHashable : Any]?#>) in
                    <#code#>
                }, option: <#T##QNUploadOption!#>)
            }
        }) { (error) in
            //do nothing
        }
    }
}
