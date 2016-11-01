//
//  RoomYKModel.swift
//  DYZB
//
//  Created by xiudou on 16/10/31.
//  Copyright © 2016年 xiudo. All rights reserved.
//  此处用的是YK的模型

import UIKit
class RoomYKModel: NSObject {

 /// 直播流地址
//    var stream_addr : String = ""
//    /// 关注人
//    var online_users : Int = 0
//    /// 城市
//    var city : String = ""
//    /// 分享地址
//    var share_addr : String = ""
    
    
    /** 直播图 */
    var bigpic : String = ""
    /** 主播头像 */
    var smallpic : String = ""
    /** 直播流地址 */
    var flv : String = ""
    /** 所在城市 */
    var gps : String = ""
//    /** 主播名 */
    var myname : String = ""
//    /** 个性签名 */
    var signatures : String = ""
//    /** 用户ID */
    var userId : String = ""
//    /** 星级 */
    var starlevel : Int = 0
    /** 朝阳群众数目 */
    var allnum : Int64 = 0
    /** 这玩意未知 */
    var lrCurrent : Int64 = 0
    /** 直播房间号码 */
    var roomid : Int64 = 0
    /** 所处服务器 */
    var serverid : Int64 = 0
    /** 用户ID */
    var useridx : Int64 = 0
    /** 排名 */
    var pos : Int64 = 0
    /** starImage */

    
    override init() {
        
    }
    
    init(dic : [String : NSObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
