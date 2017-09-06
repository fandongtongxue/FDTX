//
//  UserInfoModel.swift
//  FDTX
//
//  Created by fandong on 2017/9/6.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import HandyJSON

class UserInfoModel: HandyJSON {
    var icon:String!
    var nickName:String!
    var uid:String!
    var introduce:String!
    var id:String!
    
//    "icon": "http://ov2uvg3mg.bkt.clouddn.com/USER_DEFAULT_ICON.jpg",
//    "nickName": "111",
//    "uid": 6,
//    "introduce": "Nothing to say",
//    "id": 1
    
    required init() {
        
    }
}
