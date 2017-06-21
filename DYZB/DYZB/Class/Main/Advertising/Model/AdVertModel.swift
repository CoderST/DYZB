//
//  AdVertModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/19.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class AdVertModel: NSObject {
    
    var adid : Int = 0
    var adtype : Int = 0
    var level : Int = 0
    // 链接地址
    var link : String = ""
    var linktype : Int = 0
    var posid : Int = 0
    var proid : Int = 0
    // 显示的名称
    var proname : String = ""
    // 显示时间
    var showtime : Int = 0
    // 显示的图片
    var srcid : String = ""
    
    // 自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
