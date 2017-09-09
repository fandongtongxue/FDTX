//
//  UserInfoModel.swift
//  FDTX
//
//  Created by fandong on 2017/9/6.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import HandyJSON
import RealmSwift
import Realm

class UserInfoModel: Object, HandyJSON {
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
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
}
