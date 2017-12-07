//
//  FDString.swift
//  FDTX
//
//  Created by fandong on 2017/12/6.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
extension String {
    //subString
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}
