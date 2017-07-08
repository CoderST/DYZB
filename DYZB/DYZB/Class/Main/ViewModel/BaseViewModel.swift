//
//  BaseViewModel.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

/// 加载主播
class BaseViewModel {
    
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    lazy var phoneStatusModel : PhoneStatusModel = PhoneStatusModel()
    
    func loadAnchDates(_ isGroup : Bool, urlString : String, parameters : [String : Any]? = nil,finishCallBack:@escaping ()->()){
        NetworkTools.requestData(.get, URLString: urlString, parameters: parameters) { (result) -> () in
            
            guard let resultDict = result as? [String : Any] else {return}
            guard let dictArray = resultDict["data"] as? [[String : Any]] else {return}
            if isGroup == true{
                for dic in dictArray{
                    let roomList = dic["room_list"] as! [[String : Any]]
                    // 处理房间里没有数据的情况
                    if roomList.count == 0{
                        
                        continue
                    }
                    debugLog(dic)
                    self.anchorGroups.append(AnchorGroup(dict: dic))
                }
                
            }else{

                
                // 2.1.创建组
                let group = AnchorGroup()
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

/// 获取时间
extension BaseViewModel {
    
    // http://capi.douyucdn.cn/api/v1/timestamp?client_sys=ios
    func updateDate(_ finishCallBack:@escaping ()->()){
        
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/timestamp?client_sys=ios") { (result) in
            
            guard let resultDict = result as? [String : Any] else { return }
            guard let error = resultDict["error"] as? Int else{
                return }
            
            if error != 0 {
                debugLog(error)
                return
            }
            
            guard let date = resultDict["data"] else { return }
            
            userDefaults.set(date, forKey: dateKey)
            userDefaults.synchronize()
            finishCallBack()
        }
    }
}

/// iPhone状态
extension BaseViewModel {
    
    func iPhoneStatus(_ finishCallBack:@escaping ()->(),_ messageCallBack:@escaping (_ message : String)->()){
        
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getStatus?token=\(TOKEN)&client_sys=ios") { (result) in
            
            guard let resultDict = result as? [String : Any] else { return }
            guard let error = resultDict["error"] as? Int else{
                return }
            
            if error != 0 {
//                debugLog(error)
                guard let data = resultDict["data"] as? String else { return }
                messageCallBack("data = \(data),error = \(error)")
                return
            }
            
            guard let dateDict = resultDict["data"] as? [String : Any] else { return }
            self.phoneStatusModel = PhoneStatusModel(dict: dateDict)
            finishCallBack()
        }
    }
}

