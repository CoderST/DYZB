//
//  RoomFollowPerson.swift
//  DYZB
//
//  Created by xiudou on 16/11/8.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class RoomFollowPerson: NSObject {

    /// 直播地址
    var flv : String = ""
    /// <#Description#>
    var new : Int64 = 0
    var nickname : String = ""
    /// 照片地址
    var photo : String = ""
    /// 所在地区
    var position : String = ""
    /// 房间号
    var roomid : Int64 = 0
    /// 服务器号
    var serverid : Int64 = 0
    /// 性别
    var sex : Int64 = 0
    /// 等级
    var starlevel : Int64 = 0
    /// 用户id
    var useridx : Int64 = 0
    
    
    override init() {
        
    }
    
    init(dic : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
