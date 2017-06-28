//
//  ProfileViewModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/21.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {

    var user : User?
    
    // 本地cell数据数组
    var groupDatas : [ProfileGroupModel] = [ProfileGroupModel]()
    
    
    func loadProfileDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        let group = DispatchGroup()
        group.enter()
        // 第一组数据
        let recruit = ProfileModel(imageName: "image_my_recruitment", titleName: "主播招募", subTitleName: "", targetClass: RecruitViewController.self)
        let groupOne = ProfileGroupModel()
        groupOne.groupModels = [recruit]
        
        // 第二组数据
        let myVideo = ProfileModel(imageName: "image_my_video_icon", titleName: "我的视频", subTitleName: "", targetClass: RecruitViewController.self)
        let videoCollect = ProfileModel(imageName: "image_my_video_collection", titleName: "视频收藏", subTitleName: "", targetClass: RecruitViewController.self)
        let groupTwo = ProfileGroupModel()
        groupTwo.groupModels = [myVideo,videoCollect]
        
        // 第三组数据
        let myAccount = ProfileModel(imageName: "image_my_account", titleName: "我的账户", subTitleName: "", targetClass: RecruitViewController.self)
        let platCenter = ProfileModel(imageName: "image_my_recommend", titleName: "游戏中心", subTitleName: "", targetClass: GameCenterViewController.self)
        let groupThree = ProfileGroupModel()
        groupThree.groupModels = [myAccount,platCenter]
        
        // 第四组数据
        let remind = ProfileModel(imageName: "image_my_remind", titleName: "开播提醒", subTitleName: "", targetClass: RecruitViewController.self)
        let groupFour = ProfileGroupModel()
        groupFour.groupModels = [remind]
        
        groupDatas = [groupOne,groupTwo,groupThree,groupFour]

        group.leave()
        
//        let now = Date()
//        //当前时间的时间戳
//        let timeInterval:TimeInterval = now.timeIntervalSince1970
//        let timeStamp = Int(timeInterval)
        /*
         posid	800001
         roomid	0
         */
        let params = ["token" : TOKEN]
        let URLString = String(format: "http://capi.douyucdn.cn/api/v1/my_info?aid=ios&client_sys=ios&time=%@&auth=%@", Date.getNowDate(),AUTH)
        group.enter()
        NetworkTools.requestData(.post, URLString: URLString, parameters: params) { (result) in
            guard let result = result as? [String : Any] else {
                failCallBack()
                return }
            
            guard let error = result["error"] as? Int else{
                failCallBack()
                return }
            
            if error != 0 {
                group.leave()
                debugLog(result)
                failCallBack()
                return
            }
            guard let dict = result["data"] as? [String : Any] else {
                failCallBack()
                return }
            self.user = User(dict: dict)
            debugLog(dict)
            group.leave()
            finishCallBack()
        }

    }

}
