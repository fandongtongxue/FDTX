//
//  HomeViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit
//import MediaPlayer
//import MobilePlayer

let HomeViewControllerCellId = "HomeViewControllerCellId"
let array = ["WebView","Unsplash","Music","Video"]

class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
        self.title = "Home"
        self.view.addSubview(self.tableView)
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
//        let playerVC = MobilePlayerViewController(contentURL: URL.init(string: "http://om2bks7xs.bkt.clouddn.com/2017-08-26-Markdown-Advance-Video.mp4")!)
//        present(playerVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewControllerCellId)!
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.black
        cell.textLabel?.text = array[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
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
        let tableView : UITableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.black
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
