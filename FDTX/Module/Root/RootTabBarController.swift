//
//  RootTabBarController.swift
//  FDTX
//
//  Created by fandong on 2017/8/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        self.initViewControllers()
    }
    
    func initViewControllers() {
        let homeVC = HomeViewController.init(nibName: nil, bundle: nil)
        let homeNav = RootNavigationController.init(rootViewController: homeVC)
        let homeItem = UITabBarItem.init(tabBarSystemItem: .featured, tag: 0)
        homeNav.tabBarItem = homeItem
        self.viewControllers = [homeNav]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
