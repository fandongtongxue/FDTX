//
//  ChannelDetailViewController.swift
//  FDTX
//
//  Created by fandong on 2017/10/27.
//  Copyright © 2017年 fandong. All rights reserved.
//

import Foundation
import UIKit
import NightNight
import BMPlayer

class VideoViewController: BaseViewController {
    
    var videoUrl = ""
    var videoTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.mixedBackgroundColor = MixedColor.init(normal: .black, night: .white)
        let player = BMPlayer()
        view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            // Note here, the aspect ratio 16:9 priority is lower than 1000 on the line, because the 4S iPhone aspect ratio is not 16:9
            make.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        // Back button event
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true { return }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        let res0 = BMPlayerResourceDefinition(url: URL(string: videoUrl)!,
                                              definition: "HD")
        
        let asset = BMPlayerResource(name: videoTitle,
                                     definitions: [res0])
        player.setVideo(resource: asset)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
