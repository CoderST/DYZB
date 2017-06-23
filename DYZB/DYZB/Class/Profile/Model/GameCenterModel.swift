//
//  GameCenterModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class GameCenterModel: NSObject {

    var call_back_url : String = ""
    var click_type : String = ""
    var ctime : String = ""
    var depict : String = ""
    var end_time : String = ""
    var get_depict : String = ""
    var gift_icon : String = ""
    var icon : String = ""
    var icon_small : String = ""
    var id : String = ""
    var send_gold : String = ""
    var sort : String = ""
    var start_time : String = ""
    var status : String = ""
    var title : String = ""
    var show_type : String = ""
    var banner : String = ""
    var ios_id : String = ""
    var down_ios_url : String = ""
    var android_id : String = ""
    var down_an_url : String = ""
    var show_count : Int = 0
 
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
