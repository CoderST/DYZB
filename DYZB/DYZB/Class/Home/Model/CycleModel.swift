//
//  CycleModel.swift
//  DYZB
//
//  Created by xiudou on 16/9/23.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class CycleModel: NSObject {

    // 标题
    var title : String = ""
    // 展示的图片地址
    var pic_url : String = ""
    
    
    override init() {
        
    }
    
    // 自定义构造函数
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
