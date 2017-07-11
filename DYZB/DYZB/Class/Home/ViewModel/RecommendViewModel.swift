//
//  RecommendViewModel.swift
//  DYZB
//
//  Created by xiudou on 16/9/20.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
class RecommendViewModel : BaseViewModel{
    
    // MARK:- 懒加载属性
    // 轮播图
    lazy var cycleDatas : [CycleModel] = [CycleModel]()
    /// 最热
    fileprivate lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    /// 颜值
    fileprivate lazy var prettyGroup : AnchorGroup = AnchorGroup()
    /// 游戏
//    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    
    
    // MARK:- 轮播图数据
    func requestCycleData(_ finishCallBack:@escaping ()->()){
        // 设定参数
        let parameters = ["version" : "2.300"]
        // 发送网络请求
        NetworkTools.requestData(.get, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: parameters) { (result) -> () in
            guard let result = result as? [String : NSObject] else { return }
            
            guard let resultDataArray = result["data"] as? [[String : Any]] else {return}
            
            for dict in resultDataArray{
                let cycleModel = CycleModel(dict: dict)
                self.cycleDatas.append(cycleModel)
            }
            
            finishCallBack()
        }
    }
    
    func request(_ finishCallBack : @escaping ()->()){
        // 设定参数
        let group = DispatchGroup()
        let pareameters = ["limit" : "4" , "offset" : "0", "time" : Date.getNowDate()]
        debugLog("\(Date.getNowDate())")
        group.enter()
        // MARK:- 发送最热请求
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: pareameters) { (result) -> () in
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let dictArray = resultDict["data"] as? [[String : NSObject]] else {return}
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            for dict in dictArray{
                self.bigDataGroup.anchors.append(AnchorModel(dict: dict))
            }
            group.leave()
            
        }
        
        // MARK:- 颜值请求
        group.enter()
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: pareameters) { (result) -> () in
            guard let resultDict = result as? [String : NSObject] else {return}
            
            guard let dictArray = resultDict["data"] as? [[String : NSObject]] else {return}
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            for dict in dictArray{
                self.prettyGroup.anchors.append(AnchorModel(dict: dict))
            }
            
            group.leave()
            
        }
        
        // MARK:- 游戏请求
        /*
        经过我的抓取数据发现
        http://capi.douyucdn.cn/api/v1/getHotCate?aid=ios&client_sys=ios&time=1477668000&auth=5e75eff0b108c909fe48a05e8073e05b
        http://capi.douyucdn.cn/api/v1/getVerticalRoom?offset=0&client_sys=ios&limit=4
        */
        group.enter()
        loadAnchDates(true, urlString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: pareameters) { () -> () in
            group.leave()
        }
        
        // 对数据进行排序
        group.notify(queue: DispatchQueue.main) { () -> Void in
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            finishCallBack()
        }
        
    }
    
}
