//
//  LiveModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/17.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class LiveModel: NSObject {
    
    // id
    var cate_id : Int = 0
    // 标题名称
    var cate_name : String = ""
    
    // 自定义构造函数 ()
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    // 必须实现,不然会报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
