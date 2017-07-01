//
//  WatchHistoryModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class WatchHistoryModel: NSObject {

    var room_id : String = ""
    var room_src : String = ""
    var vertical_src : String = ""
    var room_name : String = ""
    var show_status : String = ""
    var subject : String = ""
    var show_time : String = ""
    var lt : String = ""
    var owner_uid : String = ""
    var specific_catalog : String = ""
    var specific_status : String = ""
    var vod_quality : String = ""
    var nickname : String = ""
    var avatar : String = ""
    var avatar_mid : String = ""
    var avatar_small : String = ""
    var jumpUrl : String = ""
    
    var url : String = ""
    var game_url : String = ""
    var fans : String = ""
    var game_name : String = ""
    
    var isVertical : Int = 0
    var cate_id : Int = 0
    var ranktype : Int = 0
    var online : Int = 0
    var child_id : Int = 0

    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
