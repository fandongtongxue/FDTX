//
//  HomeViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit
import MediaPlayer
import MobilePlayer

class HomeViewController: BaseViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
        self.title = "首页"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        self.showWebVC()
//        self.showPictureVC()
//        self.showMusicPlayerVC()
        self.showVideoPlayerVC()
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
    
    func showMusicPlayerVC() {
        
    }
    
    func showVideoPlayerVC() {
        let playerVC = MobilePlayerViewController(contentURL: URL.init(string: "http://om2bks7xs.bkt.clouddn.com/2017-08-26-Markdown-Advance-Video.mp4")!)
        presentMoviePlayerViewControllerAnimated(playerVC)
    }
}
