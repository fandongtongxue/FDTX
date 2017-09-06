//
//  HomeViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/5.
//  Copyright © 2017年 fandong. All rights reserved.
//

import UIKit
import WebKit

let gHost = "blog.fandong.me"
let gShowAlertOnDidFinishLoading = false

let HomeViewControllerCellId = "HomeViewControllerCellId"
let array = ["WebView","Unsplash","Music","Video"]

class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,WKUIDelegate,GDWebViewControllerDelegate{
    
    var webVC = GDWebViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
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
//        let webVC = WebViewController.init(nibName: nil, bundle: nil)
//        webVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(webVC, animated: true)
        webVC.delegate = self
        webVC.loadURLWithString(gHost)
        webVC.toolbar.toolbarTintColor = UIColor.darkGray
        webVC.toolbar.toolbarBackgroundColor = UIColor.white
        webVC.toolbar.toolbarTranslucent = false
        webVC.allowsBackForwardNavigationGestures = true
        webVC.hidesBottomBarWhenPushed = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.webVC.showToolbar(true, animated: true)
        })
        self.navigationController?.pushViewController(self.webVC, animated: true)
    }
    
    func webViewController(_ webViewController: GDWebViewController, didChangeTitle newTitle: NSString?) {
        self.webVC.navigationController?.navigationBar.topItem?.title = newTitle as String?
    }
    
    func webViewController(_ webViewController: GDWebViewController, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webViewController(_ webViewController: GDWebViewController, didFinishLoading loadedURL: URL?) {
        if gShowAlertOnDidFinishLoading {
            webViewController.evaluateJavaScript("alert('Loaded!')", completionHandler: nil)
        }
    }
    
    func showMusicPlayerVC() {
        
    }
    
    func showVideoPlayerVC() {
        let videoVC = VideoViewController()
        videoVC.setVideoUrl(videoUrl: URL.init(string: "http://om2bks7xs.bkt.clouddn.com/2017-08-26-Markdown-Advance-Video.mp4")!)
        videoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(videoVC, animated: true)
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
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
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
