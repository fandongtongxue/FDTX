//
//  StatusListViewController.swift
//  FDTX
//
//  Created by fandong on 2017/11/17.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class StatusViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        navigationItem.title = "Status Selected"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let alert = UIAlertController.init(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (alertAction) in
            let imagePicker = UIImagePickerController.init()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction.init(title: "PhotoLibrary", style: .default, handler: { (alertAction) in
            let imagePicker = UIImagePickerController.init()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        log.info(info)
        picker.dismiss(animated: true, completion: nil)
        let image = info["UIImagePickerControllerOriginalImage"]
        TokenManager.manager.getUploadToken(success: { (token) in
            let data = UIImageJPEGRepresentation(image as! UIImage, 1.0)
            let key = String.init(format: "USER_ICON_%@", AppTool.shared.uid())
            QiniuUploadManager.default().upload(data, key:key , token: token, successBlock: { (result) in
                log.info(result)
            }, fail: { (error) in
                log.error("error:\(String(describing: error))")
            }, progressBlock: { (progress) in
                log.info(progress)
            })
        }) { (error) in
             log.error("error:\(error)")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        log.info("You Clicked Cancel")
    }
    
}
