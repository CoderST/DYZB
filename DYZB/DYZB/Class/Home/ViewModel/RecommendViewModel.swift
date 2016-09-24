//
//  RecommendViewModel.swift
//  DYZB
//
//  Created by xiudou on 16/9/20.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
class RecommendViewModel {

    // MARK:- 懒加载属性
    // 轮播图
    lazy var cycleDatas : [CycleModel] = [CycleModel]()
    
    /// 最热
    private lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    /// 颜值
    private lazy var prettyGroup : AnchorGroup = AnchorGroup()
    /// 游戏
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()

    
    // MARK:- 轮播图数据
    func requestCycleData(finishCallBack:()->()){
        // 设定参数
        let parameters = ["version" : "2.300"]
        // 发送网络请求
        NetworkTools.requestData(.GET, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: parameters) { (result) -> () in
            guard let result = result as? [String : NSObject] else { return }
            
            guard let resultDataArray = result["data"] as? [[String : NSObject]] else {return}
            
            for dict in resultDataArray{
                let cycleModel = CycleModel(dict: dict)
                self.cycleDatas.append(cycleModel)
            }
            
            finishCallBack()
        }
    }
    
    func request(finishCallBack : ()->()){
        // 设定参数
        let pareameters = ["limit" : "4" , "offset" : "0", "time" : NSDate.getNowDate()]
        let group = dispatch_group_create()
        dispatch_group_enter(group)
        // MARK:- 发送最热请求
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: pareameters) { (result) -> () in
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let dictArray = resultDict["data"] as? [[String : NSObject]] else {return}
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            for dict in dictArray{
                self.bigDataGroup.anchors.append(AnchorModel(dict: dict))
            }
            dispatch_group_leave(group)
            
        }
        
        // MARK:- 颜值请求
        dispatch_group_enter(group)
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: pareameters) { (result) -> () in
            guard let resultDict = result as? [String : NSObject] else {return}
            
            guard let dictArray = resultDict["data"] as? [[String : NSObject]] else {return}
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            for dict in dictArray{
                self.prettyGroup.anchors.append(AnchorModel(dict: dict))
            }
            
            dispatch_group_leave(group)
            
        }
        
        
        // MARK:- 游戏请求
        dispatch_group_enter(group)
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: pareameters) { (result) -> () in
            guard let resultDict = result as? [String : NSObject] else {return}
            
            guard let dictArray = resultDict["data"] as? [[String : NSObject]] else {return}
            for dict in dictArray{
                self.anchorGroups.append(AnchorGroup(dict: dict))
            }
            
            dispatch_group_leave(group)
            
        }

        // 对数据进行排序
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            self.anchorGroups.insert(self.prettyGroup, atIndex: 0)
            self.anchorGroups.insert(self.bigDataGroup, atIndex: 0)
            finishCallBack()
        }

    }
    
}
