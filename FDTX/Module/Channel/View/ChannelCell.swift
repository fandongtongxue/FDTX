//
//  ChannelCell.swift
//  FDTX
//
//  Created by 范东 on 2017/10/28.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class ChannelCell: UITableViewCell {
    var model : ChannelModel! = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        self.initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model:ChannelModel) {
        self.leftImageView.kf.setImage(with: URL.init(string:model.channelImgUrl))
        self.titleLabel.text = model.channelName
    }
    
    func initSubview() {
        self.contentView.addSubview(self.leftImageView)
        self.contentView.addSubview(self.titleLabel)
        
        self.leftImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize.init(width: 60 * 4 / 3, height: 60))
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var leftImageView : UIImageView = {
        let leftImageView = UIImageView.init(frame: CGRect.zero)
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.clipsToBounds = true
        return leftImageView
    }()
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel.init(frame: CGRect.zero)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.mixedTextColor = MixedColor.init(normal: .lightGray, night: .black)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
}
