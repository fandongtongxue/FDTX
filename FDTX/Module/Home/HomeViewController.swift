//
//  HomeViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.cyan
        self.title = "首页"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.showWebVC()
    }
    
    func showPictureVC() {
        let unsplashVC = UnsplashViewController.init(nibName: nil, bundle: nil)
        unsplashVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(unsplashVC, animated: true)
    }
    
    func showWebVC() {
        let webVC = WebViewController.init(nibName: nil, bundle: nil)
        webVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
