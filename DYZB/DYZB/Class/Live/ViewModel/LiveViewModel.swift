//
//  LiveViewModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/17.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class LiveViewModel: BaseViewModel {
    
    lazy var liveModelDatas : [LiveModel] = [LiveModel]()
    
    /// 加载标题数组
    func loadLiveTitles(_ finishCallBack:@escaping ()->()){
        
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getColumnList") { (result) in
        
//            print("result=",result)
            guard let resultDict = result as? [String : Any] else {return}
            guard let dictArray = resultDict["data"] as? [[String : NSObject]] else {return}
            
            for dict in dictArray{
                
                let liveModel = LiveModel(dict: dict)
                self.liveModelDatas.append(liveModel)
            }
            finishCallBack()
        }
        
    }
    
    /// 加载主要数据 //  http://capi.douyucdn.cn/api/v1/live?offset=0&client_sys=ios&limit=20
    func loadLiveMainDatas(_ cate_id : Int, _ finishCallBack:@escaping ()->()){
        let urlString = String(format: "http://capi.douyucdn.cn/api/v1/getColumnRoom/%d", cate_id)
        loadAnchDates(false, urlString: urlString, parameters: ["limit" : "20","offset" : "0"], finishCallBack: finishCallBack)
        
    }
}
