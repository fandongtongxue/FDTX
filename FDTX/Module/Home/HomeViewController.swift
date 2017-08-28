//
//  HomeViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit
import MediaPlayer
import PandoraPlayer

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
        self.showMusicPlayerVC()
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
        let path = Bundle.main.path(forResource: "Music_iP_The Greatest", ofType: "mp3")
        let playerVC = PandoraPlayer.configure(withPath:path!)
        navigationController?.present(playerVC, animated: true, completion: nil)
    }
}
