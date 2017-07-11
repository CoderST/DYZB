//
//  ProfileInforVM.swift
//  DYZB
//
//  Created by xiudou on 2017/7/9.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class ProfileInforVM: NSObject {

    
    func loadProfileInforDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        
        //当前时间的时间戳
        // http://capi.douyucdn.cn/api/v1/my_info?aid=ios&client_sys=ios&time=1499586480&auth=2757db9c0ee8dd444c74169b2abc0ec8
        let parameters = ["token" : TOKEN]
        let URLString = "http://capi.douyucdn.cn/api/v1/my_info?aid=ios&client_sys=ios&time=\(Date.getNowDate())&auth=\(AUTH)"
        
//        NetworkTools.requestData(.post, URLString: URLString,parameters: parameters) { (result) in
//            guard let result = result as? [String : Any] else {
//                return }
//            
//            guard let error = result["error"] as? Int else{
//                return }
//            
//            if error != 0 {
//                debugLog(error)
//                return
//            }
//            guard let dict = result["data"] as? [String : Any] else {
//                return }
//
//            let model = ProfileInforModel(user: dict)
//            
//            debugLog(dict)
//            
//            finishCallBack()
//        }

    }
}
