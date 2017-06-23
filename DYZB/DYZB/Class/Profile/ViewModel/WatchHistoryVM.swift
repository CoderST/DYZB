//
//  WatchHistoryVM.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class WatchHistoryVM: NSObject {

    lazy var watchHistoryModelArray : [WatchHistoryModel] = [WatchHistoryModel]()
    
    func loadWatchHistoryDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        // 2124270%2C1882763%2C2127419%2C573449%2C134000%2C796666
        let ids = [2124270,1882763,2127419,573449,134000,796666]
        let params = ["ids" : ids, "client_sys" : "ios"] as [String : Any]
        NetworkTools.requestData(.post, URLString: "http://capi.douyucdn.cn/api/v1/room_batch", parameters: params) { (result) in
            guard let result = result as? [String : Any] else {
                return }
           print("result = \(result)")
            guard let error = result["error"] as? Int else{
                return }
            
            if error != 0 {
                print("数据有错误!!",error,result)
                return
            }
            guard let dictArray = result["data"] as? [[String : Any]] else {
                return }
            
            for dict in dictArray{
                let watchHistoryModel = WatchHistoryModel(dict: dict)
                self.watchHistoryModelArray.append(watchHistoryModel)
            }
            finishCallBack()
        }
    }

}
