//
//  LocationSubVM.swift
//  DYZB
//
//  Created by xiudou on 2017/7/14.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class LocationSubVM: NSObject {

}

extension LocationSubVM {
    func upLoadLocationDatas(_ locationString : String ,_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        let urlString = "http://capi.douyucdn.cn/api/v1/set_userinfo_custom?aid=ios&client_sys=ios&time=\(Date.getNowDate())&auth=\(AUTH)"
        let params = ["token" : TOKEN, "location" : locationString]
        NetworkTools.requestData(.post, URLString: urlString, parameters: params) { (result) in
            guard let resultDict = result as? [String : Any] else { return }
            guard let error = resultDict["error"] as? Int else{
                return }
            
            guard let data = resultDict["data"] as? String else { return }
            if error != 0 {
                messageCallBack(data)
                return
            }
            
            finishCallBack()
        }
        
    }
}
