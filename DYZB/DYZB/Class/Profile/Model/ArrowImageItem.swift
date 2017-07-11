//
//  ArroeImageItem.swift
//  DYZB
//
//  Created by xiudou on 2017/7/10.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class ArrowImageItem: SettingItem {

    //要跳转的视图
    var VcClass : AnyClass?
    var rightImageName : String
    // 带描述信息
    init(icon : String, title: String, rightImageName : String, VcClass : AnyClass?) {
        self.VcClass = VcClass
        self.rightImageName = rightImageName
        super.init(icon: icon, title: title)
    }
}
