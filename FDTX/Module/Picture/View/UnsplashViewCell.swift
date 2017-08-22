//
//  UnsplashViewCell.swift
//  FDTX
//
//  Created by fandong on 2017/8/21.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit

class UnsplashViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubview() {
        self.contentView.addSubview(self.pictureImageView)
    }
    
    lazy var pictureImageView : UIImageView = {
        let pictureImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        return pictureImageView
    }()
}
