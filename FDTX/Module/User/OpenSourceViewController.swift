//
//  OpenSourceViewController.swift
//  FDTX
//
//  Created by fandong on 2017/9/7.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import WebKit

let OpenSourceViewControllerCellId = "OpenSourceViewControllerCellId"

class OpenSourceViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,WKUIDelegate,GDWebViewControllerDelegate {
    
    var webVC = GDWebViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.title = "Open Source App"
        self.initSubview()
        self.requestData()
    }
    
    func initSubview() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func requestData() {
        let path = Bundle.main.path(forResource: "openSource", ofType: "json")
        let url = URL.init(fileURLWithPath: path!)
        do{
            let data = try! Data.init(contentsOf: url)
            let jsonDic = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let dataDict = jsonDic["data"] as! NSDictionary
            let openSourceArray = dataDict["openSource"] as! NSArray
            for dict in openSourceArray {
                let model = OpenSourceModel.deserialize(from: (dict as! NSDictionary))
                self.dataArray.add(model!)
            }
            self.tableView.reloadData()
        }catch{
            //do nothing
        }
    }
    
    func showWebVC() {
        //        let webVC = WebViewController.init(nibName: nil, bundle: nil)
        //        webVC.hidesBottomBarWhenPushed = true
        //        self.navigationController?.pushViewController(webVC, animated: true)
        
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
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OpenSourceViewControllerCellId)
        let model = self.dataArray.object(at: indexPath.row) as! OpenSourceModel
        cell?.selectionStyle = .none
        cell?.backgroundColor = .black
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.text = model.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray.object(at: indexPath.row) as! OpenSourceModel
        webVC.delegate = self
        webVC.loadURLWithString(model.url)
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
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: OpenSourceViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var dataArray : NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
}
