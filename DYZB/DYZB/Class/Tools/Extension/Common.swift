//
//  Common.swift
//  DYZB
//
//  Created by xiudou on 16/9/16.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

let sStatusBarH : CGFloat = 20
let sNavatationBarH : CGFloat = 44
let sTabBarH : CGFloat = 49

let userDefaults = UserDefaults.standard
let historyKey : String = "historyKey"

let sScreenW = UIScreen.main.bounds.width
let sScreenH = UIScreen.main.bounds.height

let TOKEN = "94153348_11_a18f67c6400a16fd_2_22753003" // 重新获取最新
let AUTH = "0503c5fe8a235774963013ec5ffc9344"   // 取不到最新的 广告数据出不来

// MARK:- 通知
let notificationCenter = NotificationCenter.default
// 关注用户
let sNotificationName_ClickUser = "sNotificationName_ClickUser"
// 猫耳朵(副播)
let sNotificationName_TapCatClick = "sNotificationName_TapCatClick"
// 删除最近搜索记录
let sNotificationName_DelHistory = "sNotificationName_DelHistory"
// 搜索界面dismiss
let sNotificationName_Dismiss = "sNotificationName_Dismiss"

func debugLog<T>(_ message : T, file : String = #file, lineNumber : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):line:\(lineNumber)]- \(message)")
        
    #endif
}
