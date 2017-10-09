//
//  CommentModel.swift
//  FDTX
//
//  Created by fandong on 2017/10/9.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import HandyJSON

//"id": 18,
//"name": "fandong",
//"url": "",
//"date": "2017-10-09 14:48:46",
//"content": "<p>我也看过这个，作品被删除</p>\n",
//"parent": 0


class CommentModel: HandyJSON {
    var id:String!
    var name:String!
    var url:String!
    var date:String!
    var content:String!
    var parent:String!

    required init() {
        
    }
}
