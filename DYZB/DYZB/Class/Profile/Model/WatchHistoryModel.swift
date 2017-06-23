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
    var cate_id : String = ""
    var room_name : String = ""
    var status : String = ""
    var show_status : String = ""
    var subject : String = ""
    var show_time : String = ""
    var owner_uid : String = ""
    var specific_catalog : String = ""
    var specific_status : String = ""
    var vod_quality : String = ""
    var nickname : String = ""
    var url : String = ""
    var game_url : String = ""
    var jumpUrl : String = ""
    var fans : String = ""
    var game_name : String = ""
    var isVertical : Int = 0
    var ranktype : Int = 0

    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
