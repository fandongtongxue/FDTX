//
//  RootNavigationController.swift
//  FDTX
//
//  Created by fandong on 2017/8/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit
import NightNight
import Hue

class RootNavigationController: UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationBar.isTranslucent = false
        self.navigationBar.mixedTitleTextAttributes = [NNForegroundColorAttributeName:MixedColor.init(normal: .lightGray, night: .white),NSAttributedStringKey.font.rawValue:UIFont.systemFont(ofSize: 18)]
        self.navigationBar.mixedBarTintColor = MixedColor.init(normal: .black, night: UIColor(hex:"007aff"))
        self.navigationBar.mixedTintColor = MixedColor.init(normal: .lightGray, night: .white)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
