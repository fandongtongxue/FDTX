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
        let unsplashVC = UnsplashViewController.init(nibName: nil, bundle: nil)
        let unsplashNav = RootNavigationController.init(rootViewController: unsplashVC)
        let unsplashItem = UITabBarItem.init(tabBarSystemItem: .featured, tag: 0)
        unsplashNav.tabBarItem = unsplashItem
        
        
        let channelVC = ChannelListViewController.init(nibName: nil, bundle: nil)
        let channelNav = RootNavigationController.init(rootViewController: channelVC)
        let channelVCItem = UITabBarItem.init(tabBarSystemItem: .featured, tag: 0)
        channelNav.tabBarItem = channelVCItem
        
        let blogVC = GitHubPageViewController.init(nibName: nil, bundle: nil)
        let blogNav = RootNavigationController.init(rootViewController: blogVC)
        let blogItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 2)
        blogNav.tabBarItem = blogItem
        
        let videoBlogVC = WordPressViewController.init(nibName: nil, bundle: nil)
        let videoBlogNav = RootNavigationController.init(rootViewController: videoBlogVC)
        let videoBlogItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 3)
        videoBlogNav.tabBarItem = videoBlogItem
        
        let userVC = UserViewController.init(nibName: nil, bundle: nil)
        let userNav = RootNavigationController.init(rootViewController: userVC)
        let userItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 4)
        userNav.tabBarItem = userItem
        
        self.viewControllers = [unsplashNav,channelNav,blogNav,videoBlogNav,userNav]
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
