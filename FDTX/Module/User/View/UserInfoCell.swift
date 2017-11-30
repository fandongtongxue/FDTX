//
//  UserInfoCell.swift
//  FDTX
//
//  Created by fandong on 2017/11/30.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class UserInfoCell: UITableViewCell {
    
    public enum UserInfoCellType {
        case icon
        case nickName
        case introduce
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        self.initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setType(type:UserInfoCellType) {
        switch type {
        case .icon:
            leftLabel.text = "Icon"
            self.contentView.addSubview(self.rightImageView)
            self.rightImageView.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 70, height: 70))
            }
            break
        case .nickName:
            leftLabel.text = "NickName"
            self.contentView.addSubview(self.rightLabel)
            self.rightLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalToSuperview()
            }
            break
        case .introduce:
            leftLabel.text = "Introduce"
            self.contentView.addSubview(self.rightLabel)
            self.rightLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalToSuperview()
            }
            break
        default:
            //do nothing
            break
        }
    }
    
    func setValue(value:String) {
        rightLabel.text = value
        rightImageView.kf.setImage(with: URL.init(string: value))
    }
    
    func initSubview() {
        self.contentView.addSubview(self.leftLabel)
        self.leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var rightImageView : UIImageView = {
        let rightImageView = UIImageView.init(frame: CGRect.zero)
        rightImageView.contentMode = .scaleAspectFill
        rightImageView.clipsToBounds = true
        rightImageView.layer.cornerRadius = 35
        return rightImageView
    }()
    
    lazy var leftLabel : UILabel = {
        let leftLabel = UILabel.init(frame: CGRect.zero)
        leftLabel.font = UIFont.systemFont(ofSize: 13)
        leftLabel.mixedTextColor = MixedColor.init(normal: .lightGray, night: .black)
        return leftLabel
    }()
    
    lazy var rightLabel : UILabel = {
        let rightLabel = UILabel.init(frame: CGRect.zero)
        rightLabel.font = UIFont.systemFont(ofSize: 13)
        rightLabel.mixedTextColor = MixedColor.init(normal: .lightGray, night: .black)
        rightLabel.textAlignment = .right
        return rightLabel
    }()
}
