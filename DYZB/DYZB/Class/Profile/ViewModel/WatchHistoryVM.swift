//
//  WatchHistoryVM.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class WatchHistoryVM: NSObject {

    // http://capi.douyucdn.cn/api/v1/history?aid=ios&client_sys=ios&time=1498807620&auth=fe73812c89c1a6fe5671cfc31a529331
    lazy var watchHistoryModelFrameArray : [WatchHistoryModelFrame] = [WatchHistoryModelFrame]()
    
    func loadWatchHistoryDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        // 2124270%2C1882763%2C2127419%2C573449%2C134000%2C796666
        let nowDate = Date.getNowDate()
        let urlString = "http://capi.douyucdn.cn/api/v1/history?aid=ios&client_sys=ios&time=\(nowDate)&auth=fe73812c89c1a6fe5671cfc31a529331"
//        let ids = [2124270,1882763,2127419,573449,134000,796666]
        let params = ["token" : TOKEN]
        NetworkTools.requestData(.post, URLString: urlString, parameters: params) { (result) in
            guard let resultDict = result as? [String : Any] else {
//                messageCallBack(result["data"] as! String)
                return }
           print("resultttt = \(resultDict)")
            guard let error = resultDict["error"] as? Int else{
                return }
            
            if error != 0 {
                print("数据有错误!!",error,resultDict)
                return
            }
            guard let dictArray = resultDict["data"] as? [[String : Any]] else {
                return }
            
            for dict in dictArray{
                let watchHistoryModel = WatchHistoryModel(dict: dict)
                let watchHistoryModelFrame = WatchHistoryModelFrame(watchHistoryModel)
                self.watchHistoryModelFrameArray.append(watchHistoryModelFrame)
            }
            finishCallBack()
        }
    }

}

extension WatchHistoryVM{
    // http://apiv2.douyucdn.cn/Livenc/User/clearViewHistory?token=94153348_11_cd79b4bb454aed7b_2_22753003&client_sys=ios
    func clearHistory(_ finishCallBack : @escaping ()->()){
        let urlString = "http://apiv2.douyucdn.cn/Livenc/User/clearViewHistory?token=\(TOKEN)&client_sys=ios"
        NetworkTools.requestData(.get, URLString: urlString) { (result) in
            guard let resultDict = result as? [String : Any] else {
                return }
            print(result,resultDict)
            guard let error = resultDict["error"] as? Int else{
                return }
            
            if error != 0 {
                print("数据有错误!!",error,resultDict)
                return
            }

            guard let _ = resultDict["data"] as? String else { return }
            self.watchHistoryModelFrameArray.removeAll()
            finishCallBack()
        }
    }
}
