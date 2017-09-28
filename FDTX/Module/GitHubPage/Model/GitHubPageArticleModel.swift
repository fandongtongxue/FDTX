//
//  GitHubPageArticleModel.swift
//  FDTX
//
//  Created by fandong on 2017/9/19.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import HandyJSON

class GitHubPageArticleModel: HandyJSON {
    var title : String!
    var url : String!
    var date : String!
    var author : String!
    var header_img : String!
    var subtitle : String!
    var content : String!
    
    
    required init() {
        
    }
}
