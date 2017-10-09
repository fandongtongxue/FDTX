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

class WebViewController: BaseViewController,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate {
    
    var url = "http://fandong.me"
    
    var HTMLString = ""
    
    var isArticle = false
    
    var post_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Loading..."
        self.view.addSubview(self.webView)
        if HTMLString != "" {
            self.webView.loadHTMLString(HTMLString, baseURL: URL.init(string: url))
        }else{
            self.webView.load(NSURLRequest.init(url: URL.init(string: self.url)!) as URLRequest)
        }
        if isArticle {
            self.view.addSubview(self.bottomView)
            self.bottomView.post_id = self.post_id
            self.bottomView.snp.makeConstraints({ (make) in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(TABBAR_HEIGHT + (UIDevice.current.isiPhoneX() ? STATUSBAR_HEIGHT : 0))
            })
            self.webView.snp.makeConstraints { (make) in
//                make.edges.equalToSuperview()
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(self.bottomView.snp.top)
            }
        }else{
            self.webView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
    }
    //Lazy Load
    lazy var webView : WKWebView = {
        let configuration = WKWebViewConfiguration.init()
        let userContentController = WKUserContentController.init()
        let js = "var meta = document.createElement('meta'); meta.name = 'viewport'; meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no' var head = document.getElementsByTagName('head')[0]; head.appendChild(meta);"
        userContentController.addUserScript(WKUserScript.init(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        configuration.userContentController = userContentController
        let webView : WKWebView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        return webView
    }()
    
    lazy var bottomView : BottomCommentView = {
        let bottomView = BottomCommentView.init(frame: .zero)
        return bottomView
    }()
    
    //WebViewNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("网页开始加载")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("网页加载完成")
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("网页加载失败")
    }
    
    //UIScrollViewDelegate
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return nil
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
