//
//  UserHeaderView.swift
//  FDTX
//
//  Created by fandong on 2017/9/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit

class UserHeaderView: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        self.addSubview(self.bgView)
        self.addSubview(self.effectView)
        self.addSubview(self.shadowView)
        self.addSubview(self.iconView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.introduceLabel)
        
        self.bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.shadowView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.iconView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(NAVIGATIONBAR_HEIGHT)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 70, height: 70))
        }
        self.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        self.introduceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func setModel(model:UserInfoModel) {
        self.bgView.kf.setImage(with: URL.init(string: model.icon))
        self.iconView.kf.setImage(with: URL.init(string: model.icon))
        self.nameLabel.text = model.nickName
        self.introduceLabel.text = model.introduce
    }
    
    lazy var bgView : UIImageView = {
        let bgView = UIImageView.init()
        return bgView;
    }()
    
    lazy var effectView : UIVisualEffectView = {
        let effectView = UIVisualEffectView.init()
        effectView.effect = UIBlurEffect.init(style: .light)
        return effectView
    }()
    
    lazy var shadowView : UIView = {
        let shadowView = UIView.init()
        shadowView.backgroundColor = .black
        shadowView.alpha = 0.3
        return shadowView;
    }()
    
    lazy var iconView : UIImageView = {
        let iconView = UIImageView.init()
        iconView.layer.cornerRadius = 35
        iconView.clipsToBounds = true
        return iconView;
    }()
    
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel.init()
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textAlignment = .center
        return nameLabel;
    }()
    
    lazy var introduceLabel : UILabel = {
        let introduceLabel = UILabel.init()
        introduceLabel.textColor = .white
        introduceLabel.font = UIFont.systemFont(ofSize: 13)
        introduceLabel.textAlignment = .center
        introduceLabel.numberOfLines = 0
        return introduceLabel;
    }()
}
