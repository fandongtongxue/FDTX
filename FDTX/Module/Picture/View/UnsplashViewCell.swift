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
        self.pictureImageView.kf.setImage(with: URL.init(string: model.urls.regular))
        self.iconImageView.kf.setImage(with: URL.init(string: model.user.profile_image.large))
        self.nameLabel.text = model.user.name
        self.introduceLabel.text = model.user.bio
        let screenWidth = Float(SCREEN_WIDTH)
        let pictureHeight = CGFloat((model.height as NSString).floatValue * screenWidth / (model.width as NSString).floatValue)
        self.pictureImageView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: pictureHeight)
        self.iconImageView.frame = CGRect.init(x: 10, y: pictureHeight - 50 - 10, width: 50, height: 50)
        self.nameLabel.frame = CGRect.init(x: self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 10, y: pictureHeight - 50 - 5, width: SCREEN_WIDTH - 3*10 - 50, height: 20)
        self.introduceLabel.frame = CGRect.init(x: self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 10, y: self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 5, width: SCREEN_WIDTH - 3*10 - 50, height: 15)
    }
    
    func initSubview() {
        self.contentView.addSubview(self.pictureImageView)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.introduceLabel)
    }
    
    lazy var pictureImageView : UIImageView = {
        let pictureImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.clipsToBounds = true
        return pictureImageView
    }()
    
    lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 25
        iconImageView.clipsToBounds = true
        return iconImageView
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel.init(frame: CGRect.init(x: self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 10, y: 0, width: SCREEN_WIDTH - 3*10 - 50, height: 20))
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textColor = UIColor.white
        return nameLabel
    }()
    
    lazy var introduceLabel : UILabel = {
        let introduceLabel = UILabel.init(frame: CGRect.init(x: self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 10, y: 0, width: SCREEN_WIDTH - 3*10 - 50, height: 15))
        introduceLabel.font = UIFont.systemFont(ofSize: 13)
        introduceLabel.textColor = UIColor.white
        return introduceLabel
    }()
}
