//
//  ProfileInforVM.swift
//  DYZB
//
//  Created by xiudou on 2017/7/9.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class ProfileInforVM: NSObject {

    var user : User?
}

extension ProfileInforVM {
    
    func loadProfileInforDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        let params = ["token" : TOKEN]
        let URLString = String(format: "http://capi.douyucdn.cn/api/v1/my_info?aid=ios&client_sys=ios&time=%@&auth=%@", Date.getNowDate(),AUTH)
        NetworkTools.requestData(.post, URLString: URLString, parameters: params) { (result) in
            guard let result = result as? [String : Any] else {
                failCallBack()
                return }
            
            guard let error = result["error"] as? Int else{
                failCallBack()
                return }
            
            if error != 0 {
                debugLog(result)
                failCallBack()
                return
            }
            guard let dict = result["data"] as? [String : Any] else {
                failCallBack()
                return }
            self.user = User(dict: dict)
            debugLog(dict)
            finishCallBack()
        }
    }
}

// 上传头像
extension ProfileInforVM {
    func loadUpImageProfileInforDatas(imageData : Data, _ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        let parameters = ["token" : TOKEN, "Filedata" : imageData] as [String : Any]
        let URLString = "http://capi.douyucdn.cn/api/v1/set_userinfo?aid=ios&client_sys=ios&key=txpic&time=\(Date.getNowDate())&auth=\(AUTH)"
        NetworkTools.requestData(.post, URLString: URLString, parameters: parameters) { (result) in
            debugLog(result)
        }
    }
}

// 选择性别
extension ProfileInforVM {
    
    func loadSexProfileInforDatas(sexString : String, _ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        let parameters = ["token" : TOKEN, "sex" : sexString]
        let URLString = "http://capi.douyucdn.cn/api/v1/set_userinfo_custom?aid=ios&client_sys=ios&time=\(Date.getNowDate())&auth=\(AUTH)"
        NetworkTools.requestData(.post, URLString: URLString, parameters: parameters) { (result) in
            debugLog(result)
            guard let resultDict = result as? [String : Any] else { return }
            guard let error = resultDict["error"] as? Int else{
                return }
            guard let data = resultDict["data"] as? String else { return }
            
            if error != 0 {
                debugLog(error)
               messageCallBack(data)
                return
            }

            finishCallBack()
            
        }
    }
}

// 生日
extension ProfileInforVM {
    func loadBirthDayProfileInforDatas(birthDay : String, _ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        let parameters = ["token" : TOKEN, "birthday" : birthDay]
        let URLString = "http://capi.douyucdn.cn/api/v1/set_userinfo_custom?aid=ios&client_sys=ios&time=\(Date.getNowDate())&auth=\(AUTH)"
        NetworkTools.requestData(.post, URLString: URLString, parameters: parameters) { (result) in
            debugLog(result)
            guard let resultDict = result as? [String : Any] else { return }
            guard let error = resultDict["error"] as? Int else{
                return }
            guard let data = resultDict["data"] as? String else { return }
            
            if error != 0 {
                debugLog(error)
                messageCallBack(data)
                return
            }
            
            finishCallBack()
        }
    }

}
