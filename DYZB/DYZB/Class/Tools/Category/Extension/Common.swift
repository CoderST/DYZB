//
//  Common.swift
//  DYZB
//
//  Created by xiudou on 16/9/16.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

let sScreenW = UIScreen.main.bounds.width
let sScreenH = UIScreen.main.bounds.height
let sStatusBarH : CGFloat = 20
let sNavatationBarH : CGFloat = 44
let sTabBarH : CGFloat = 49

let userDefaults = UserDefaults.standard
let historyKey : String = "historyKey"
let dateKey : String = "dateKey"

// MARK:- tag值
let AreaCodeTextFieldTag : Int = 1000
let IPhoneNumberTextFieldTag : Int = 1001
let VerificationCodeTextFieldTag : Int = 1002
let VoiceTextFieldTag : Int = 1003

// MARK:- TOKEN/AUTH
let TOKEN = "94153348_11_4c28b846a6af724a_2_22753003" // 重新获取最新
let AUTH = "dcd11dd7d51157aeb8939489ce353044"   // 取不到最新的 广告数据出不来

let RecommentGameAllID : String = "10000"

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
// 搜索Room界面dismiss
let sNotificationName_RoomDismiss = "sNotificationName_RoomDismiss"
// 再次刷新ProfileInforViewController界面
let sNotificationName_ReLoadProfileInforData = "sNotificationName_ReLoadProfileInforData"

// MARK:- 打印
func delog(filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
        let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        print(fileName + "/" + "\(rowCount)" + "\n")
    #endif
}

func debugLog<T>(_ message: T, filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
        let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        print(fileName + "/" + "\(rowCount)" + " \(message)" + "\n")
    #endif
}

/// 获取MainNavigationController
func getNavigation()->MainNavigationController{
    let window = UIApplication.shared.keyWindow!
    let tabVC = window.rootViewController as!UITabBarController
    let nav = tabVC.selectedViewController as!MainNavigationController
    
    return nav
}

