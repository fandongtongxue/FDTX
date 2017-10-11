//
//  UnsplashViewCell.swift
//  FDTX
//
//  Created by fandong on 2017/8/21.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class UnsplashViewCell: UITableViewCell {
    
    var model : UnsplashPictureModel! = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        self.initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model:UnsplashPictureModel) {
        self.pictureImageView.kf.setImage(with: URL.init(string: model.urls.small))
        self.iconImageView.kf.setImage(with: URL.init(string: model.user.profile_image.large))
        self.nameLabel.text = model.user.name
        self.introduceLabel.text = model.user.bio
    }
    
    func initSubview() {
        self.contentView.addSubview(self.pictureImageView)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.introduceLabel)
        
        self.pictureImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.iconImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize.init(width: 50, height: 50))
        }
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
            make.top.equalTo(self.iconImageView.snp.top).offset(5)
        }
        self.introduceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    lazy var pictureImageView : UIImageView = {
        let pictureImageView = UIImageView.init(frame: CGRect.zero)
        pictureImageView.contentMode = .scaleAspectFit
        pictureImageView.clipsToBounds = true
        return pictureImageView
    }()
    
    lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView.init(frame: CGRect.zero)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 25
        iconImageView.clipsToBounds = true
        return iconImageView
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel.init(frame: CGRect.zero)
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textColor = UIColor.white
        return nameLabel
    }()
    
    lazy var introduceLabel : UILabel = {
        let introduceLabel = UILabel.init(frame: CGRect.zero)
        introduceLabel.font = UIFont.systemFont(ofSize: 13)
        introduceLabel.textColor = UIColor.white
        return introduceLabel
    }()
}
