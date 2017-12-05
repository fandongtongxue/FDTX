//
//  StatusCell.swift
//  FDTX
//
//  Created by fandong on 2017/12/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import HandyJSON

class StatusModel: HandyJSON {
    
    var uid : String!
    var content : String!
    var imgUrls : String!
    var location : String!
    var likeCount : String!
    var commentCount : String!
    var shareCount : String!
    
    required init() {
        
    }
}
