//
//  ChannelCommentCell.swift
//  FDTX
//
//  Created by 范东 on 2017/10/31.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class ChannelCommentCell: UITableViewCell {
    var model : ChannelCommentModel! = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        self.initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model:ChannelCommentModel) {
        self.titleLabel.text = model.comment
        self.timeLabel.text = model.createTime
    }
    
    func initSubview() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.timeLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel.init(frame: CGRect.zero)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.mixedTextColor = MixedColor.init(normal: .lightGray, night: .black)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var timeLabel : UILabel = {
        let timeLabel = UILabel.init(frame: CGRect.zero)
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.mixedTextColor = MixedColor.init(normal: .lightGray, night: .black)
        timeLabel.numberOfLines = 0
        return timeLabel
    }()
}
