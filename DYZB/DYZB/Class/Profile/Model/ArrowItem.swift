//
//  ArrowItem.swift
//  DYZB
//
//  Created by xiudou on 2017/7/10.
//  Copyright © 2017年 xiudo. All rights reserved.
//  带有箭头

import UIKit

class ArrowItem: SettingItem {
    //要跳转的视图
    var VcClass : AnyClass?
    // 普通的箭头
    init(icon : String, title: String, VcClass : AnyClass?) {
        self.VcClass = VcClass
        super.init(icon: icon, title: title)
    }
    
    // 带描述信息
    init(icon : String, title: String, subtitle : String, VcClass : AnyClass?) {
        self.VcClass = VcClass
        super.init(icon: icon, title: title, subTitle: subtitle)
    }
    
}
