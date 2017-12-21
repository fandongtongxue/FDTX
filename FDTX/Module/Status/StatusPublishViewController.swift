//
//  StatusPublishViewController.swift
//  FDTX
//
//  Created by 范东 on 2017/12/2.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import PKHUD
import AssetsPickerViewController
import Photos

class StatusPublishViewController: BaseViewController,AssetsPickerViewControllerDelegate,UITextViewDelegate {
    
    var selectedAssets:[PHAsset] = []
    var imgUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title = "Publish Status"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "common_btn_dismiss"), style: .plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "status_btn_publish"), style: .plain, target: self, action: #selector(publishFirst))
        navigationItem.rightBarButtonItem?.isEnabled = false
        initSubview()
        textView.becomeFirstResponder()
    }
    
    func initSubview() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(SCREEN_WIDTH)
        }
        scrollView.addSubview(addImgBtn)
        addImgBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(self.textView.snp.bottom).offset(10)
            make.size.equalTo(CGSize.init(width: (( SCREEN_WIDTH - 20 ) / 3), height: (( SCREEN_WIDTH - 20 ) / 3)))
        }
        scrollView.addSubview(locationBtn)
        locationBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(self.addImgBtn.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH, height: 100 + 10 + (( SCREEN_WIDTH - 20 ) / 3) + 10 + 22 + 10)
    }
    
    //Action
    @objc func back() {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func publishFirst() {
        textView.resignFirstResponder()
        let key = String.init(format: "USER_STATUS_UID_%@_DATE_%@.jpg", AppTool.shared.uid(),AppTool.shared.translateDateToString(originDate: Date.init(timeIntervalSinceNow: 0)));
        let image = addImgBtn.backgroundImage(for: .normal)
        if image != UIImage.init(named: "status_btn_addImg") {
            let size = CGSize.init(width: 30, height: 30)
            self.startAnimating(size, message: "Uploading", messageFont: UIFont.systemFont(ofSize: 15), type: .lineScalePulseOut, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: UIColor.black, textColor: UIColor.white)
            
            TokenManager.manager.getUploadToken(success: { (token) in
                QiniuUploadManager.default().uploadImage(image, key: key, token: token, successBlock: { (result) in
                    self.stopAnimating()
                    HUD.flash(.label("Update Image Success"), delay: HUD_DELAY_TIME)
                    self.imgUrl = QINIU_URL + key
                    self.publishSecond()
                }, fail: { (error) in
                    self.stopAnimating()
                    HUD.flash(.label(String.init(format: "%@", error! as CVarArg)), delay: HUD_DELAY_TIME)
                }, progressBlock: { (progress) in
                    log.info(progress)
                })
            }, failure: { (error) in
                self.stopAnimating()
                HUD.flash(.label(String.init(format: "%@", error as CVarArg)), delay: HUD_DELAY_TIME)
            })
        }else{
            publishSecond()
        }
    }
    
    func publishSecond() {
        let location = locationBtn.titleLabel?.text == " where are you?" ? "Mars" : locationBtn.titleLabel?.text
        let params = ["uid":AppTool.shared.uid(),
                      "imgUrls":imgUrl,
                      "content":textView.text!,
                      "location":location!]
        BaseNetwoking.manager.POST(url: "statusPublish", parameters: params, success: { (response) in
            self.perform(#selector(self.back), with: nil, afterDelay: HUD_DELAY_TIME)
        }) { (error) in
            HUD.flash(.label(String.init(format: "%@", error as CVarArg)), delay: HUD_DELAY_TIME)
        }
    }
    
    @objc func addImg(){
        let image = addImgBtn.backgroundImage(for: .normal)
        if image != UIImage.init(named: "status_btn_addImg") {
            //do nothing
        }else{
            let config = AssetsPickerConfig.init()
            config.albumIsShowEmptyAlbum = false
            let picker = AssetsPickerViewController.init(pickerConfig: config)
            picker.pickerDelegate = self
            present(picker, animated: true, completion: nil)
        }
    }
    
    @objc func deleteImg(){
        addImgBtn.setBackgroundImage(UIImage.init(named: "status_btn_addImg"), for: .normal)
        addImgBtn.setBackgroundImage(UIImage.init(named: "status_btn_addImg"), for: .highlighted)
        deleteImgBtn.removeFromSuperview()
    }
    
    @objc func locationBtnAction(){
        textView.resignFirstResponder()
        
        let size = CGSize.init(width: 30, height: 30)
        self.startAnimating(size, message: "Locating", messageFont: UIFont.systemFont(ofSize: 15), type: .lineScalePulseOut, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: UIColor.black, textColor: UIColor.white)
        MapManager.default().startUpdatingLocationFinish({ (address) in
            self.stopAnimating()
            self.locationBtn.setTitle(address, for: .normal)
        }) { (error) in
            self.stopAnimating()
            self.locationBtn.setTitle("Mars", for: .normal)
            HUD.flash(.label(String.init(format: "%@", error! as CVarArg)), delay: HUD_DELAY_TIME)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    //AssetsPickerViewControllerDelegate
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        
    }
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didDismissByCancelling byCancel: Bool) {
        if !byCancel{
            let assetArray = controller.selectedAssets
            var imageArray : [UIImage] = []
            
            for asset in assetArray.enumerated() {
                let manager = PHImageManager.default()
                let options = PHImageRequestOptions()
                let PHImageRequestID = manager.requestImage(for: asset.element, targetSize: CGSize.init(width: SCREEN_WIDTH - 20, height: CGFloat(MAXFLOAT)), contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    imageArray.append(image!)
                    if imageArray.count == 2{
                        self.addImgBtn.setBackgroundImage(imageArray.last, for: .normal)
                        self.addImgBtn.setBackgroundImage(imageArray.last, for: .highlighted)
                        self.addImgBtn.addSubview(self.deleteImgBtn)
                        self.deleteImgBtn.snp.makeConstraints({ (make) in
                            make.top.right.equalToSuperview()
                            make.size.equalTo(CGSize.init(width: 44, height: 44))
                        })
                        if self.textView.text.count > 0{
                            self.navigationItem.rightBarButtonItem?.isEnabled = true
                        }else{
                            self.navigationItem.rightBarButtonItem?.isEnabled = false
                        }
                        self.scrollView.contentSize = CGSize.init(width: SCREEN_WIDTH, height: 100 + 10 + (( SCREEN_WIDTH - 20 ) / 3) + 10 + 22 + 10)
                    }
                })
                log.info(PHImageRequestID)
            }
        }
    }
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        // do your job with selected assets
        selectedAssets = assets
    }
    
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        if controller.selectedAssets.count == 1 {
            return false
        }
        return true
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
        
    }
    
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {
        
    }
    
    //UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    //Lazy Load
    lazy var textView:UITextView = {
        let textView = UITextView.init(frame: .zero)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.delegate = self
        return textView
    }()
    
    lazy var addImgBtn:UIButton = {
        let addImgBtn = UIButton.init(frame: .zero)
        addImgBtn.setBackgroundImage(UIImage.init(named: "status_btn_addImg"), for: .normal)
        addImgBtn.setBackgroundImage(UIImage.init(named: "status_btn_addImg"), for: .highlighted)
        addImgBtn.addTarget(self, action: #selector(addImg), for: .touchUpInside)
        return addImgBtn
    }()
    
    lazy var deleteImgBtn:UIButton = {
        let deleteImgBtn = UIButton.init(frame: .zero)
        deleteImgBtn.setBackgroundImage(UIImage.init(named: "status_btn_deleteImg"), for: .normal)
        deleteImgBtn.setBackgroundImage(UIImage.init(named: "status_btn_deleteImg"), for: .highlighted)
        deleteImgBtn.addTarget(self, action: #selector(deleteImg), for: .touchUpInside)
        return deleteImgBtn
    }()
    
    lazy var locationBtn:UIButton = {
        let locationBtn = UIButton.init(frame: .zero)
        locationBtn.setImage(UIImage.init(named: "status_btn_location"), for: .normal)
        locationBtn.setImage(UIImage.init(named: "status_btn_location"), for: .highlighted)
        locationBtn.addTarget(self, action: #selector(locationBtnAction), for: .touchUpInside)
        locationBtn.setTitle(" where are you?", for: .normal)
        locationBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        locationBtn.setTitleColor(UIColor.black, for: .normal)
        return locationBtn
    }()
    
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView.init(frame: .zero)
        return scrollView
    }()
    
}
