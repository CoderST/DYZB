//
//  RoomAnchorVM.swift
//  DYZB
//
//  Created by xiudou on 16/10/30.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class RoomAnchorVM: NSObject {

    private let urlS = "http://live.9158.com/Fans/GetHotLive?page=1"
    
//    lazy var roomAnchor : RoomAnchorModel = RoomAnchorModel()
    lazy var roomYKModelArray : [RoomYKModel] = [RoomYKModel]()
    
    func getRoomAnchorData(room_id : Int64,finishCallBack : ()->()){
        
        
        // 此处用的是YK/MB的链接
        let urlString = urlS
        
//        let roomID = String(room_id)
//        let uu = "http://capi.douyucdn.cn/api/v1/room/" + roomID
//        let urlString = uu + "?aid=ios&client_sys=ios&ne=1&support_pwd=1&time=" + NSDate.getNowDate()
        
//        let ustr = urlString + "&auth" + auth
        
//        let url = "http://capi.douyucdn.cn/api/v1/room/1136293?aid=ios&client_sys=ios&ne=1&support_pwd=1&time=" + NSDate.getNowDate()
//        
//        let urlString = "http://capi.douyucdn.cn/api/v1/room/" + roomID
        
//        let pareameters = ["aid" : "ios" , "ne" : "1", "support_pwd" : "1" ,"time" : NSDate.getNowDate()]
        
        print(urlString,NSDate.getNowDate())
        
        NetworkTools.requestData(.GET ,URLString: urlString, parameters: nil) { (result) -> () in
            
//            print(result)
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let dict = resultDict["data"] as? [String : NSObject] else { return }
            guard let dictArray = dict["list"] as? [[String : NSObject]] else { return }
            for dic in dictArray{
                
                let roomYkM = RoomYKModel(dic: dic)
                
                self.roomYKModelArray.append(roomYkM)
            }
//            let roomModel =  RoomAnchorModel(dict: dict)
//            self.roomAnchor = roomModel
            finishCallBack()
            
        }
    }
}
