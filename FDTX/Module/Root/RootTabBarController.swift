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
//        let unsplashVC = UnsplashViewController.init(nibName: nil, bundle: nil)
//        let unsplashNav = RootNavigationController.init(rootViewController: unsplashVC)
//        let unsplashItem = UITabBarItem.init(title: "Picture", image: UIImage.init(named: "nav_img_nor"), selectedImage: UIImage.init(named: "nav_img_sel"))
//        unsplashNav.tabBarItem = unsplashItem
        
        let chatVC = ChatViewController.init(nibName: nil, bundle: nil)
        let chatNav = RootNavigationController.init(rootViewController: chatVC)
        let chatItem = UITabBarItem.init(title: "Chat", image: UIImage.init(named: "nav_chat_nor"), selectedImage: UIImage.init(named: "nav_chat_sel"))
        chatNav.tabBarItem = chatItem
        
        let statusVC = StatusViewController.init(nibName: nil, bundle: nil)
        let statusNav = RootNavigationController.init(rootViewController: statusVC)
        let statusItem = UITabBarItem.init(title: "Status", image: UIImage.init(named: "nav_status_nor"), selectedImage: UIImage.init(named: "nav_status_sel"))
        statusNav.tabBarItem = statusItem
        
//        let channelVC = ChannelViewController.init(nibName: nil, bundle: nil)
//        let channelNav = RootNavigationController.init(rootViewController: channelVC)
//        let channelVCItem = UITabBarItem.init(title: "TV", image: UIImage.init(named: "nav_tv_nor"), selectedImage: UIImage.init(named: "nav_tv_sel"))
//        channelNav.tabBarItem = channelVCItem
        
//        let blogVC = GitHubPageViewController.init(nibName: nil, bundle: nil)
//        let blogNav = RootNavigationController.init(rootViewController: blogVC)
//        let blogItem = UITabBarItem.init(title: "Article", image: UIImage.init(named: "nav_article_nor"), selectedImage: UIImage.init(named: "nav_article_sel"))
//        blogNav.tabBarItem = blogItem
        
        let userVC = UserViewController.init(nibName: nil, bundle: nil)
        let userNav = RootNavigationController.init(rootViewController: userVC)
        let userItem = UITabBarItem.init(title: "User", image: UIImage.init(named: "nav_user_nor"), selectedImage: UIImage.init(named: "nav_user_sel"))
        userNav.tabBarItem = userItem
        
        self.viewControllers = [chatNav,statusNav,userNav]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
