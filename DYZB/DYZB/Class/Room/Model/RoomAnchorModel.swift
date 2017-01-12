//
//  RoomAnchorModel.swift
//  DYZB
//
//  Created by xiudou on 16/10/30.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class RoomAnchorModel: NSObject {

    /// 房间ID
    var room_id = 0.0
    /// 拉流数据
    var hls_url : String = ""
    /// 粉丝数量
    var fans : double_t = 0
    /// 主播昵称
    var nickname : String = ""
    /// 观看人数
    var online : Int = 0
    /// 所在城市
    var anchor_city : String = ""
    
    override init() {
        
    }
    
    // 自定义构造函数 ()
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    // 必须实现,不然会报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // MARK:- 重写description属性(方便打印看到信息)
    override var description:String{
        return dictionaryWithValues(forKeys: ["isVertical", "room_name", "nickname"]).description
    }
    
}

