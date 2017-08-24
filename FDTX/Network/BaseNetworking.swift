//
//  BaseNetworking.swift
//  FDTX
//
//  Created by fandong on 2017/8/13.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import Alamofire

class BaseNetworking: NSObject {
    func get(url:String) {
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            switch response.result{
            case .success:
                if response.result.value != nil{
//                    print(result)
                    
                }
            case.failure(let error):
                print(error)
            }
        }
    }
}
