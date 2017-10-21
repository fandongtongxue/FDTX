//
//  UnsplashViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/19.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import NightNight
import MediaBrowser
import Photos

let UnsplashViewControllerCellId = "UnsplashViewControllerCellId"
let UnsplashUrl = "https://api.unsplash.com/photos/?client_id=522f34661134a2300e6d94d344a7ab6424e028a51b31353363b7a8cce11d73b6&per_page=20&page="

class UnsplashViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    var page : NSInteger = 1
    
    var selections = [Bool]()
    
    var raws = [Media]()
    var thumbs = [Media]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        self.title = "Unsplash Selected"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.addSubview(self.refreshControl)
        self.requestFirstPageData()
    }
    
    func requestFirstPageData(){
        
        if !self.refreshControl.isRefreshing {
            let size = CGSize.init(width: 30, height: 30)
            startAnimating(size, message: "Loading", messageFont: UIFont.systemFont(ofSize: 15), type: .lineScalePulseOut, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: UIColor.black, textColor: UIColor.white)
        }
        
        page = 1
        let firstUrl = UnsplashUrl + String.init(format: "%d", page)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(firstUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            self.stopAnimating()
            switch response.result{
            case .success:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.dataArray.removeAllObjects()
                if let result = response.result.value{
                    let array = result as! NSArray
                    self.dataArray.removeAllObjects()
                    for dict in array{
                        let model = UnsplashPictureModel.deserialize(from: dict as? NSDictionary)
                        self.dataArray.add(model!)
                    }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            case.failure(let error):
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                log.error(error)
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnsplashViewControllerCellId) as! UnsplashViewCell
        let model = self.dataArray.object(at: indexPath.row) as! UnsplashPictureModel
        cell.setModel(model: model);
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArray.object(at: indexPath.row) as! UnsplashPictureModel
        let screenWidth = Float(SCREEN_WIDTH)
        return CGFloat((model.height as NSString).floatValue * screenWidth / (model.width as NSString).floatValue)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray.object(at: indexPath.row) as! UnsplashPictureModel
        log.info(model.urls.regular)
        //PhotoBrowser
        raws = self.getRaws()
        thumbs = self.getThumbs()
        let browser = MediaBrowser(delegate: self)
        browser.displayActionButton = true
        browser.displayMediaNavigationArrows = false
        browser.displaySelectionButtons = false
        browser.alwaysShowControls = false
        browser.zoomPhotosToFill = true
        browser.enableGrid = false
        browser.startOnGrid = false
        browser.enableSwipeToDismiss = true
        browser.autoPlayOnAppear = false
        browser.cachingImageCount = 2
        browser.setCurrentIndex(at: indexPath.row)
        self.navigationController?.pushViewController(browser, animated: true)
    }
    
    func getRaws() -> [Media] {
        for model in dataArray {
            let media = Media.init(url: URL.init(string: (model as! UnsplashPictureModel).urls.regular)!)
            raws.append(media)
        }
        return raws
    }
    
    
    func getThumbs() -> [Media] {
        for model in dataArray {
            let media = Media.init(url: URL.init(string: (model as! UnsplashPictureModel).urls.thumb)!)
            thumbs.append(media)
        }
        return thumbs
    }
    
    //懒加载
    lazy var dataArray : NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
    
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UnsplashViewCell.classForCoder(), forCellReuseIdentifier: UnsplashViewControllerCellId)
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        return tableView
    }()
    lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl.init()
        refreshControl.mixedTintColor = MixedColor.init(normal: .white, night: .black)
        refreshControl.addTarget(self, action: #selector(requestFirstPageData), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: MediaBrowserDelegate
extension UnsplashViewController: MediaBrowserDelegate {
    func thumbnail(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
        if index < thumbs.count {
            return thumbs[index]
        }
        return DemoData.localMediaPhoto(imageName: "iTunesArtwork", caption: "ThumbPhoto at index is wrong")
    }
    
    func media(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
        if index < raws.count {
            return raws[index]
        }
        return DemoData.localMediaPhoto(imageName: "iTunesArtwork", caption: "Photo at index is Wrong")
    }
    
    func numberOfMedia(in mediaBrowser: MediaBrowser) -> Int {
        return raws.count
    }
    
    func isMediaSelected(at index: Int, in mediaBrowser: MediaBrowser) -> Bool {
        return selections[index]
    }
    
    func didDisplayMedia(at index: Int, in mediaBrowser: MediaBrowser) {
        log.info("Did start viewing photo at index \(index)")
    }
    
    func mediaDid(selected: Bool, at index: Int, in mediaBrowser: MediaBrowser) {
        selections[index] = selected
    }
    
    func titleForPhotoAtIndex(index: Int, MediaBrowser: MediaBrowser) -> String {
        return "Title"
    }
}
