//
//  SettingItem.swift
//  DYZB
//
//  Created by xiudou on 2017/7/10.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class SettingItem: NSObject {

    //左边图
    var icon : String?
    //标题
    var title : String = ""
    //子标题
    var subTitle : String = ""
    
    // 事件闭包
    var optionHandler : (()->())?
    
    // 闭包
    var optionHeight : (()->CGFloat)?
    
    init(icon : String?, title : String) {
        self.icon = icon
        self.title = title
        super.init()
    }
    
    init(icon : String?,title : String,subTitle : String) {
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        super.init()
    }
}
