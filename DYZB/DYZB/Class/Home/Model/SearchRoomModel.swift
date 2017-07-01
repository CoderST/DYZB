//
//  SearchCateModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/29.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class SearchRoomModel: NSObject {
    
    var tag_id : String = ""
    var short_name : String = ""
    var tag_name : String = ""
    var tag_introduce : String = ""
    var pic_name2 : String = ""
    var icon_name : String = ""
    var small_icon_name : String = ""
    var orderdisplay : String = ""
    var rank_score : String = ""
    var night_rank_score : String = ""
    var nums : String = ""
    var push_ios : String = ""
    var push_home : String = ""
    var is_game_cate : String = ""
    var cate_id : String = ""
    var is_del : String = ""
    var push_vertical_screen : String = ""
    var push_nearby : String = ""
    var push_qqapp : String = ""
    var broadcast_limit : String = ""
    var vodd_cateids : String = ""
    var open_full_screen : String = ""
    var pic_url : String = ""
    var pic_url2 : String = ""
    var url : String = ""
    var icon_url : String = ""
    var small_icon_url : String = ""
    var square_icon_url_w : String = ""
    var square_icon_url_m : String = ""
    var noRed : String = ""
    var nickname : String = ""
    var room_name : String = ""
    var roomSrc : String = ""
    var cateName : String = ""
    var icon : String = ""
    var nrNickname : String = ""
    var avatar : String = ""
    var jumpUrl : String = ""
    var verticalSrc : String = ""
    
    var room_id : Int = 0
    var count : Int = 0
    var shownum : Int = 0
    var count_ios : Int = 0
    var popularity : Int = 0
    var follow : Int = 0
    var isLive : Int = 0
    var isVertical : Int = 0
    var tagId : Int = 0
    
    // 记录每一个ITEM的宽高
    var width : CGFloat = 0
    var height : CGFloat = 0
    
    var reusableViewTitle : String = ""
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
