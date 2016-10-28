//
//  BaseViewModel.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class BaseViewModel {
    
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    
    func loadAnchDates(isGroup : Bool, urlString : String, parameters : [String : AnyObject]? = nil,finishCallBack:()->()){
        NetworkTools.requestData(.GET, URLString: urlString, parameters: parameters) { (result) -> () in
            
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let dictArray = resultDict["data"] as? [[String : NSObject]] else {return}
            if isGroup == true{
                for dic in dictArray{
                    let roomList = dic["room_list"] as! [[String : AnyObject]]
                    //                    print("roomList==\(roomList)")
                    // 处理房间里没有数据的情况
                    if roomList.count == 0{
                        
                        continue
                    }
                    
                    self.anchorGroups.append(AnchorGroup(dic: dic))
                }
                
            }else{
//                for dic in dictArray{
//                    let roomList = dic["room_list"] as! [[String : AnyObject]]
//                    //                    print("roomList==\(roomList)")
//                    // 处理房间里没有数据的情况
//                    if roomList.count == 0{
//                        
//                        continue
//                    }
//                    
//                    // 2.3.将group,添加到anchorGroups
//                    self.anchorGroups.append(AnchorGroup(dic: dic))
//                }
                
                // 2.1.创建组
                let group = AnchorGroup()
//                print("dictArray = \(dictArray)")
                // 2.2.遍历dataArray的所有的字典
                for dict in dictArray {
                    group.anchors.append(AnchorModel(dict: dict))
                }
                
                // 2.3.将group,添加到anchorGroups
                self.anchorGroups.append(group)

                
                
            }
            finishCallBack()
        }
        
    }
}
