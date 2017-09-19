//
//  VideoViewController.swift
//  FDTX
//
//  Created by fandong on 2017/8/30.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import BMPlayer
import NightNight

class VideoViewController: BaseViewController {
    
    let isFullScreen = false
    
    let player = BMPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(0)
            make.left.right.equalTo(self.view)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        player.backBlock = { [unowned self](isFullScreen) in
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setVideoUrl(videoUrl : URL) {
        let asset = BMPlayerResource(url: videoUrl,
                                     name: "Video Title")
        player.setVideo(resource: asset)
    }
}
