//
//  WebViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/21.
//  Copyright © 2017年 fandong. All rights reserved.
//  通用WebView控制器

import Foundation
import UIKit
import WebKit

let markdownURL = "http://ov2uvg3mg.bkt.clouddn.com/2017-08-21-iOS-Interview.markdown"

class WebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "浏览器"
        self.view.addSubview(self.webView)
        self.webView.load(URLRequest.init(url: URL.init(string:"http://baidu.com")!))
    }
    //Lazy Load
    lazy var webView : WKWebView = {
        let configuration = WKWebViewConfiguration.init()
        let webView : WKWebView = WKWebView.init(frame: self.view.bounds, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    //WebViewNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("网页开始加载")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("网页加载完成")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("网页加载失败")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
