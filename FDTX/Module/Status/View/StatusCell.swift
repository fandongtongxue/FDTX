//
//  StatusCell.swift
//  FDTX
//
//  Created by fandong on 2017/12/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import NightNight

class StatusCell: UITableViewCell {
    var model : StatusModel! = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model:StatusModel) {
        iconImageView.kf.setImage(with: URL.init(string: model.userIcon))
        nameLabel.text = model.userNickName
        contentLabel.text = model.content
        contentImageView.kf.setImage(with: URL.init(string: model.imgUrls))
        locationLabel.text = model.location
    }
    
    func initSubview() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(contentImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(lineView)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
            make.top.equalTo(self.iconImageView.snp.top).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        contentImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - 20)
            make.height.lessThanOrEqualTo(SCREEN_WIDTH - 20)
        }
        
        locationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var totalHeight:CGFloat = 0
        totalHeight += 44
        totalHeight += contentLabel.sizeThatFits(size).height
        totalHeight += contentImageView.sizeThatFits(size).height < SCREEN_WIDTH - 20 ? contentImageView.sizeThatFits(size).height : SCREEN_WIDTH - 20
        totalHeight += locationLabel.sizeThatFits(size).height
        totalHeight += 50.0
        return CGSize.init(width: size.width, height: totalHeight)
    }
    
    lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView.init(frame: CGRect.zero)
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 22
        iconImageView.clipsToBounds = true
        return iconImageView
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel.init(frame: CGRect.zero)
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.mixedTextColor = MixedColor.init(normal: .lightGray, night: .black)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    lazy var contentLabel : UILabel = {
        let contentLabel = UILabel.init(frame: CGRect.zero)
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.mixedTextColor = MixedColor.init(normal: .lightGray, night: .black)
        contentLabel.numberOfLines = 0
        return contentLabel
    }() 
    
    lazy var contentImageView : UIImageView = {
        let contentImageView = UIImageView.init(frame: CGRect.zero)
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.clipsToBounds = true
        return contentImageView
    }()
    
    lazy var locationLabel : UILabel = {
        let locationLabel = UILabel.init(frame: CGRect.zero)
        locationLabel.font = UIFont.systemFont(ofSize: 15)
        locationLabel.mixedTextColor = MixedColor.init(normal: .lightGray, night: .lightGray)
        locationLabel.numberOfLines = 0
        return locationLabel
    }()
    
    lazy var lineView : UIView = {
        let lineView = UIView.init(frame: .zero)
        lineView.backgroundColor = UIColor(hex:"cccccc")
        return lineView
    }()
}
