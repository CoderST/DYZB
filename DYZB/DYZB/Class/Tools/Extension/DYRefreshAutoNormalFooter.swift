//
//  DYRefreshAutoNormalFooter.swift
//  DYZB
//
//  Created by xiudou on 16/11/6.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import MJRefresh
class DYRefreshAutoNormalFooter: MJRefreshAutoStateFooter {

    override func prepare() {
        super.prepare()
        // 控制底部的高度
        mj_h = 0
        automaticallyChangeAlpha = true
//        automaticallyHidden = true
        // 控制拖拽显示的比例
        triggerAutomaticallyRefreshPercent = -10.0
    }
    
    override func placeSubviews() {
        
    }

}
