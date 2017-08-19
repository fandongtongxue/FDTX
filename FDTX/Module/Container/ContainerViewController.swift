//
//  ContainerViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit

class ContainViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tabBarVC = RootTabBarController.init(nibName: nil, bundle: nil)
        self.addChildViewController(tabBarVC)
        self.view.addSubview(tabBarVC.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
