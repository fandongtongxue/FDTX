//
//  ChannelModel.swift
//  FDTX
//
//  Created by 范东 on 2017/10/21.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import HandyJSON

class ChannelModel: HandyJSON {
    var channelId : String!
    var channelName : String!
    var channelUrl : String!
    var channelImgUrl : String!
    
    required init() {
        
    }
}
