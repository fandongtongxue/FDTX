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
    func subString(start:Int, length:Int = -1)->String {
        var len = length
        if len == -1 {
            len = characters.count - start
        }
        let st = characters.index(startIndex, offsetBy:start)
        let en = characters.index(st, offsetBy:len)
        let range = st ..< en
        return substring(with:range)
    }
    func boundsWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let bounds = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return bounds
    }
    func widthWithConstrainedWidth(width: CGFloat, font: UIFont) -> Float {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let bounds = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return Float(bounds.width)
    }
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let bounds = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return bounds.height
    }
    
}
