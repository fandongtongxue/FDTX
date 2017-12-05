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
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(150)
        }
        view.addSubview(addImgBtn)
        addImgBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(self.textView.snp.bottom).offset(10)
        }
    }
    
    //Action
    @objc func back() {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func publishFirst() {
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
        let params = ["uid":AppTool.shared.uid(),
                      "imgUrls":self.imgUrl,
                      "content":self.textView.text!,
                      "location":"北京市石景山区古城路小区"]
        BaseNetwoking.manager.POST(url: "statusPublish", parameters: params, success: { (response) in
            self.perform(#selector(self.back), with: nil, afterDelay: HUD_DELAY_TIME)
        }) { (error) in
            HUD.flash(.label(String.init(format: "%@", error as CVarArg)), delay: HUD_DELAY_TIME)
        }
    }
    
    @objc func addImg(){
        let config = AssetsPickerConfig.init()
        config.albumIsShowEmptyAlbum = false
        config.selectedAssets = self.selectedAssets
        let picker = AssetsPickerViewController.init(pickerConfig: config)
        picker.pickerDelegate = self
        present(picker, animated: true, completion: nil)
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
                    if (image?.size.width)! > SCREEN_WIDTH - 20{
                        let newSize = CGSize.init(width: SCREEN_WIDTH - 20, height: (image?.size.height)! * (SCREEN_WIDTH - 20) / (image?.size.width)!)
                        let newImage = AppTool.shared.resizeImage(image: image!, newSize: newSize)
                        imageArray.append(newImage)
                    }else{
                        imageArray.append(image!)
                    }
                    if imageArray.count == 2{
                        self.addImgBtn.setBackgroundImage(imageArray.last, for: .normal)
                        if self.textView.text.count > 0{
                            self.navigationItem.rightBarButtonItem?.isEnabled = true
                        }else{
                            self.navigationItem.rightBarButtonItem?.isEnabled = false
                        }
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
    
    lazy var addImgBtn : UIButton = {
        let addImgBtn = UIButton.init(frame: .zero)
        addImgBtn.setBackgroundImage(UIImage.init(named: "status_btn_addImg"), for: .normal)
        addImgBtn.addTarget(self, action: #selector(addImg), for: .touchUpInside)
        return addImgBtn
    }()
    
}
