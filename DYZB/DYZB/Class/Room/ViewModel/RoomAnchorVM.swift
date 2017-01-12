//
//  RoomAnchorVM.swift
//  DYZB
//
//  Created by xiudou on 16/10/30.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class RoomAnchorVM: NSObject {

    fileprivate let urlS = "http://live.9158.com/Fans/GetHotLive?page="
    
//    lazy var roomAnchor : RoomAnchorModel = RoomAnchorModel()
    lazy var roomYKModelArray : [RoomYKModel] = [RoomYKModel]()
    
    func getRoomAnchorData(_ page : Int,finishCallBack : @escaping ()->(),noDataCallBack:@escaping ()->()){
        
        
        // 此处用的是YK/MB的链接
        let urlString = urlS + String(page)
        print(urlString)
        NetworkTools.requestData(.get ,URLString: urlString, parameters: nil) { (result) -> () in
//            print("page==\(page)",result)
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let dict = resultDict["data"] as? [String : NSObject] else { return }
            guard let dictArray = dict["list"] as? [[String : NSObject]] else { return }
            
            if dictArray.count == 0{
                noDataCallBack()
                return
            }
            
            if page == 1{
                self.roomYKModelArray.removeAll()
            }
            for dic in dictArray{
                
                let roomYkM = RoomYKModel(dic: dic)
//                print(roomYkM.myname)
                self.roomYKModelArray.append(roomYkM)
            }
//            let roomModel =  RoomAnchorModel(dict: dict)
//            self.roomAnchor = roomModel
            finishCallBack()
            
        }
    }
    
    
    
}
