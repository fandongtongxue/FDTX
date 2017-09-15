//
//  HomeViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit
import WebKit
import NightNight
import SwiftWebVC

let webViewUrl = "blog.fandong.me"

let HomeViewControllerCellId = "HomeViewControllerCellId"
let array = ["WebView","Unsplash","Music","Video"]

class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        self.title = "Home"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func showPictureVC() {
        let unsplashVC = UnsplashViewController.init(nibName: nil, bundle: nil)
        unsplashVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(unsplashVC, animated: true)
    }
    
    func showWebVC() {
        let webVC = SwiftWebVC(urlString: webViewUrl)
        webVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    func showMusicPlayerVC() {
        
    }
    
    func showVideoPlayerVC() {
        let videoVC = VideoViewController()
        videoVC.setVideoUrl(videoUrl: URL.init(string: "http://223.110.245.139:80/PLTV/3/224/3221226977/index.m3u8")!)
        videoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(videoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewControllerCellId)!
        cell.selectionStyle = .none
        cell.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        cell.textLabel?.text = array[indexPath.row]
        cell.textLabel?.mixedTextColor = MixedColor.init(normal: .white, night: .black)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.showWebVC()
            break
        case 1:
            self.showPictureVC()
            break
        case 2:
            self.showMusicPlayerVC()
            break
        case 3:
            self.showVideoPlayerVC()
            break
        default:
            //do nothing
            break
        }
    }
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: HomeViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
}
