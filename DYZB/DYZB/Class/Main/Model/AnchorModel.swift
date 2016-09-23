//
//  AnchorModel.swift
//  DYZB
//
//  Created by xiudou on 16/9/20.
//  Copyright © 2016年 xiudo. All rights reserved.
//  主播模型

import UIKit

class AnchorModel: NSObject {
    
    
    /// 房间ID
    var room_id : Int = 0
    /// 房间图片对应的URLString
    var vertical_src : String = ""
    /// 判断是手机直播还是电脑直播
    // 0 : 电脑直播 1 : 手机直播
    var isVertical : Int = 0
    /// 房间名称
    var room_name : String = ""
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
        setValuesForKeysWithDictionary(dict)
    }
    // 必须实现,不然会报错
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // MARK:- 重写description属性(方便打印看到信息)
    override var description:String{
        return dictionaryWithValuesForKeys(["isVertical", "room_name", "nickname"]).description
    }
    
}
