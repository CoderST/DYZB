//
//  InteralMessageVM.swift
//  DYZB
//
//  Created by xiudou on 2017/7/3.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class InteralMessageVM: NSObject {
    
    lazy var interalMessageModelArray : [InteralMessageModel] = [InteralMessageModel]()
    
    func loadInteralMessageDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        // 2124270%2C1882763%2C2127419%2C573449%2C134000%2C796666
        let nowDate = Date.getNowDate()
        let urlString = "http://capi.douyucdn.cn/api/v1/ncpmApi/inbox/20?aid=ios&client_sys=ios&page=1&time=\(nowDate)&auth=\(AUTH)"
        //        let ids = [2124270,1882763,2127419,573449,134000,796666]
        let params = ["token" : TOKEN]
        NetworkTools.requestData(.post, URLString: urlString, parameters: params) { (result) in
            guard let resultDict = result as? [String : Any] else {
                
                return }
//            print("resultttt = \(resultDict)")
            guard let error = resultDict["error"] as? Int else{
                return }
            
            if error != 0 {
                print("数据有错误!!",error,resultDict)
                return
            }
            
            guard let resultDataDict = resultDict["data"] as? [String : Any] else {
                return }
            
            guard let dictArray = resultDataDict["record"] as? [[String : Any]] else { return }
            
            for dict in dictArray{
                let model = InteralMessageModel(dict: dict)
                self.interalMessageModelArray.append(model)
            }
            
            finishCallBack()
        }
    }
}
