//
//  GitHubPageArticleCell.swift
//  FDTX
//
//  Created by fandong on 2017/9/30.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class GitHubPageArticleCell: UITableViewCell {
    var model : GitHubPageArticleModel! = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        self.initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model:GitHubPageArticleModel) {
        self.leftImageView.kf.setImage(with: URL.init(string:GITHUB_URL + model.header_img))
        self.titleLabel.text = model.title
        self.timeLabel.text = model.date
    }
    
    func initSubview() {
        self.contentView.addSubview(self.leftImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.timeLabel)
        
        self.leftImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize.init(width: 60 * 4 / 3, height: 60))
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftImageView.snp.right).offset(10)
//            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-10);
            make.right.equalToSuperview().offset(-10)
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
        titleLabel.mixedTextColor = MixedColor.init(normal: .white, night: .black)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var timeLabel : UILabel = {
        let timeLabel = UILabel.init(frame: CGRect.zero)
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.mixedTextColor = MixedColor.init(normal: .white, night: .black)
        return timeLabel
    }()
}
