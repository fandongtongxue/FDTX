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

class StatusPublishViewController: BaseViewController,AssetsPickerViewControllerDelegate {
    
    var selectedAssets:[PHAsset] = []
    var imgUrlArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        title = "Publish Status"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "common_btn_dismiss"), style: .plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "status_btn_publish"), style: .plain, target: self, action: #selector(publish))
        
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func publish() {
        let params = ["uid":AppTool.shared.uid(),
                      "imgUrls":imgUrlArray.joined(separator: ","),
                      "content":"和你们在一起很开心！",
                      "location":"北京市石景山区古城路小区"]
        BaseNetwoking.manager.POST(url: "statusPublish", parameters: params, success: { (response) in
            self.perform(#selector(self.back), with: nil, afterDelay: HUD_DELAY_TIME)
        }) { (error) in
            HUD.flash(.label(String.init(format: "%@", error as CVarArg)), delay: HUD_DELAY_TIME)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
        let size = CGSize.init(width: 30, height: 30)
        self.startAnimating(size, message: "Uploading", messageFont: UIFont.systemFont(ofSize: 15), type: .lineScalePulseOut, color: UIColor.white, padding: 0, displayTimeThreshold: 0, minimumDisplayTime: 1, backgroundColor: UIColor.black, textColor: UIColor.white)
        
        let assetArray = controller.selectedAssets
        var keyArray:[String] = []
        for asset in assetArray.enumerated() {
            let key = String.init(format: "USER_STATUS_UID_%@_DATE_%@.jpg", AppTool.shared.uid(),AppTool.shared.translateDateToString(originDate: Date.init(timeIntervalSinceNow: TimeInterval(asset.offset))));
            keyArray.append(key)
        }
        TokenManager.manager.getUploadToken(success: { (token) in
            QiniuUploadManager.default().uploadMutiPHAsset(assetArray, keyArray: keyArray, token: token, successBlock: { (result) in
                self.stopAnimating()
                HUD.flash(.label("Update Image Success"), delay: HUD_DELAY_TIME)
                self.imgUrlArray = result as! [String]
            }, fail: { (error) in
                self.stopAnimating()
                HUD.flash(.label(String.init(format: "%@", error! as CVarArg)), delay: HUD_DELAY_TIME)
            }, progressBlock: { (progress) in
                log.info(progress)
            })
        }) { (error) in
            self.stopAnimating()
            HUD.flash(.label(String.init(format: "%@", error as CVarArg)), delay: HUD_DELAY_TIME)
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
    
    //Lazy Load
    lazy var textView:UITextView = {
        let textView = UITextView.init(frame: .zero)
        return textView
    }()
    
}
