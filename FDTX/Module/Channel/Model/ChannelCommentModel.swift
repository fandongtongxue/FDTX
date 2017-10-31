//
//  ChannelCommentModel.swift
//  FDTX
//
//  Created by 范东 on 2017/10/31.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import HandyJSON

class ChannelCommentModel: HandyJSON {
    var channelId : String!
    var comment : String!
    var createTime : String!
    var uid : String!
    
    required init() {
        
    }
}
