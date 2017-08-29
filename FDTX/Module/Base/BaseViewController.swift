//
//  BaseViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/13.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit
import HandyJSON
import Kingfisher

class BaseViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

