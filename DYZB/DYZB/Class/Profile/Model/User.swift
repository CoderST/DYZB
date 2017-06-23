//
//  User.swift
//  DYZB
//
//  Created by xiudou on 2017/6/21.
//  Copyright © 2017年 xiudo. All rights reserved.
//  网络用户数据

import UIKit

class User: NSObject {

    var avatar : [String : String]?
    var birthday : Int = 0
    var email : Int = 0
    var follow : Int = 0
    var gold : String = ""
    var gold1 = 0
    var groupid = 1
    var mobile_phone : String = ""
    var nickname : String = ""
    var phone_status : Int = 0
    var qq : String = ""
    var sex : Int = 0
    var uid : Int = 0
    // 自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
