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
    
    var model : UnsplashPictureModel! = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.black
        self.initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model:UnsplashPictureModel) {
        self.pictureImageView.kf.setImage(with: URL.init(string: model.urls.thumb))
        let screenWidth = Float(SCREEN_WIDTH)
        self.pictureImageView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat((model.height as NSString).floatValue * screenWidth / (model.width as NSString).floatValue))
    }
    
    func initSubview() {
        self.contentView.addSubview(self.pictureImageView)
    }
    
    lazy var pictureImageView : UIImageView = {
        let pictureImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.clipsToBounds = true
        return pictureImageView
    }()
    
    lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        return iconImageView
    }()
}
