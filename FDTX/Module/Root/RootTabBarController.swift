//
//  RootTabBarController.swift
//  FDTX
//
//  Created by fandong on 2017/8/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit
import NightNight

class RootTabBarController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        self.tabBar.mixedBarTintColor = MixedColor.init(normal: .black, night: .white)
        self.initViewControllers()
    }
    
    func initViewControllers() {
        let homeVC = HomeViewController.init(nibName: nil, bundle: nil)
        let homeNav = RootNavigationController.init(rootViewController: homeVC)
        let homeItem = UITabBarItem.init(tabBarSystemItem: .featured, tag: 0)
        homeNav.tabBarItem = homeItem
        
        let blogVC = GitHubPageViewController.init(nibName: nil, bundle: nil)
        let blogNav = RootNavigationController.init(rootViewController: blogVC)
        let blogItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 1)
        blogNav.tabBarItem = blogItem
        
        let videoBlogVC = WordPressViewController.init(nibName: nil, bundle: nil)
        let videoBlogNav = RootNavigationController.init(rootViewController: videoBlogVC)
        let videoBlogItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 2)
        videoBlogNav.tabBarItem = videoBlogItem
        
        let userVC = UserViewController.init(nibName: nil, bundle: nil)
        let userNav = RootNavigationController.init(rootViewController: userVC)
        let userItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 3)
        userNav.tabBarItem = userItem
        
        self.viewControllers = [homeNav,blogNav,videoBlogNav,userNav]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch self.selectedIndex {
        case 0:
            if !AppTool.shared.isLogin() {
                let loginVC = LoginViewController()
                loginVC.hidesBottomBarWhenPushed = true
                let loginNav = RootNavigationController.init(rootViewController: loginVC)
                present(loginNav, animated: true, completion: nil)
            }
            break
        case 1:
            //do nothing
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
