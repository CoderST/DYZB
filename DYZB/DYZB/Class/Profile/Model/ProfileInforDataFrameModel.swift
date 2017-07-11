//
//  ProfileInforModel.swift
//  DYZB
//
//  Created by xiudou on 2017/7/9.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let margin : CGFloat = 10

enum sexStringType : String{
    case none = "0"   // 未选择
    case man = "1"    // 男
    case woman = "2"  // 女
}
class ProfileInforDataFrameModel: NSObject {
    
    
    // MARK:- 处理好的数据
    /// 头像
    var avatarName : String = ""
    /// 昵称
    var nickname : String = ""
    /// 性别
    var sexType : sexStringType = .none
    var sexString : String = ""   // 0 未填写 1 男 2 女
    /// 生日
    var birthdayString : String = ""
    /// 所在地
    var locationString : String = ""
    
    /// 实名认证
    var realNameAuthentication : String = ""
    /// 密码
    var passWord : String = ""
    /// 邮箱
    var emailString : String = ""
    /// 手机
    var mobile_phoneString : String = ""
    /// QQ
    var qq : String = ""
    
    
    /// 经验值
    var empiricalValue : String = ""
    /// 鱼丸
    var fishBall : String = ""
    /// 鱼翅
    var fin : String = ""
    
    
    init(user : User) {
        super.init()
        /// 昵称
        nickname = user.nickname
        /// 头像
        if let avatar = user.avatar{  // 单独处理  高度不一样
            avatarName = avatar.small
        }
        
        // 性别
        if user.sex == sexStringType.none.rawValue {
            sexString = "未选择"
        }else if user.sex == sexStringType.man.rawValue{
            sexString = "男"
        }else{
            sexString = "女"
        }
        
        // 生日
        if let birthday = Date.getTimeFromeFormat(timeDateFormat: "yyyyMMdd", toDateFormat: "yyyy-MM-dd", time: user.birthday){
            
            birthdayString = birthday
        }else{
            birthdayString = "未填写"
        }
        
        // 所在地
        if let location = user.location{
            if location.city.characters.count > 0{
                locationString = "\(location.province) \(location.city)"
            }else{
                locationString = location.province
            }
            
        }else{
            locationString = "未选择"
        }
        
        
        /// 实名认证
        realNameAuthentication = "未认证"
        /// 密码
        passWord = "111111"
        /// 邮箱
        if user.email_status == "0" {
            emailString = "未绑定"
        }else{
            emailString = user.email
        }
        /// 手机
        if user.mobile_phone.characters.count > 0 {
            mobile_phoneString = user.mobile_phone
        }else{
            mobile_phoneString = "未绑定"
        }
        /// QQ
        var qq : String = ""
        if user.qq == "" {
           qq = "未填写"
        }else{
            qq = user.qq
        }
        
        /// 经验值
        empiricalValue = "0"
        /// 鱼丸
        fishBall = "0"
        /// 鱼翅
        fin = "0"

        
       
    }
    
}
