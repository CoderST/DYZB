//
//  CheckDataTool.swift
//  DYZB
//
//  Created by xiudou on 2017/7/20.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

enum regExType : String {
    case emailString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
}

class CheckDataTool: NSObject {

    // MARK:-  QQ验证
    //第一位1-9之间的数字，第二位0-9之间的数字，数字范围0-15个之间
    func checkForQQ(_ qq : String) -> Bool{
        
        let regEx = "[1-9]\\d{0,15}"
        return baseCheckForRegEx(regEx, qq)
    }
    
    // MARK:-   邮箱验证
    func checkForEmail(_ email : String) -> Bool{
        
        let regEx = regExType.emailString
        return baseCheckForRegEx(regEx.rawValue, email)
    }
    
    // MARK:-  手机号验证
    func checkForMobilePhoneNo(_ mobilePhone : String) -> Bool{

        let regEx = "^1[3|4|5|7|8][0-9]\\d{8}$"
        return baseCheckForRegEx(regEx, mobilePhone)

    }
    
    // MARK:-  电话号验证
    func checkForPhoneNo(_ phone : String) -> Bool{
        
        let regEx = "^(\\d{3,4}-)\\d{7,8}$"
        return baseCheckForRegEx(regEx, phone)
    }
    
    // MARK:-  身份证号验证(15位 或 18位)
    func checkForIdCard(_ idCard : String) -> Bool{
        
        let regEx = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)"
        return baseCheckForRegEx(regEx, idCard)
    }
    // MARK:- 密码验证
    /**
     *
     *  @param shortest 最短长度
     *  @param longest  最长长度
     *  @param pwd      密码
     *  @return 结果
     */

    func checkForPasswordWithShortest(_ shortest : String, _ longest : String, _ password : String) -> Bool{
        
        let regEx = String(format: "^[a-zA-Z0-9]{%ld,%ld}+$",shortest,longest)

        return baseCheckForRegEx(regEx, password)
    }
     
     // MARK:- 由数字和26个英文字母和数字组成的字符串
     /**
     *
     *
     *  @param idCard 数据
     *
     *  @return 结果
     */
    func checkForNumberAndCase(_ data : String) -> Bool{
        
        let regEx = "^[A-Za-z0-9]+$"
        return baseCheckForRegEx(regEx, data)
    }
    
    // MARK:- 校验只能输入26位小写字母
     /**
     *  校验只能输入26位小写字母
     *
     *  @param 数据
     *
     *  @return 结果
     */
    func checkForLowerCase(_ data : String) -> Bool{
        
        let regEx = "^[a-z]+$"
        return baseCheckForRegEx(regEx, data)
    }
    
    // MARK:- 校验只能输入26位大写字母
     /**
     *
     *
     *  @param data 数据
     *
     *  @return 结果
     */
    func checkForUpperCase(_ data : String) -> Bool{
        
        let regEx = "^[A-Z]+$"
        return baseCheckForRegEx(regEx, data)
    }
    
    // MARK:- 26位英文字母
     /**
     *
     *
     *  @param data 字符串
     *
     *  @return 结果
     */
    func checkForLowerAndUpperCase(_ data : String) -> Bool{
        
        let regEx = "^[A-Za-z]+$"
        return baseCheckForRegEx(regEx, data)
    }
    
    
    // MARK:- 是否含有特殊字符(%&’,;=?$\等)
     /**
     *
     *
     *  @param data 数据
     *
     *  @return 结果
     */
    func checkForSpecialChar(_ data : String) -> Bool{
        
        let regEx = "[^%&',;=?$\\x22]+"
        return baseCheckForRegEx(regEx, data)
    }
    
     // MARK:- 校验只能输入数字
     /**
     *
     *
     *  @param number 数字
     *
     *  @return 结果
     */
    func checkForNumber(_ number : String) -> Bool{
        
        let regEx = "^[0-9]*$"
        return baseCheckForRegEx(regEx, number)
    }
    
    // MARK:- 校验只能输入n位的数字
     /**
     *
     *
     *  @param length n位
     *  @param number 数字
     *
     *  @return 结果
     */
    func checkForNumberWithLength(_ length : String, _ number : String) -> Bool{
        let regEx = String(format: "^\\d{%@}$",length)
        return baseCheckForRegEx(regEx, number)
    }
}

extension CheckDataTool {
    /**
     *  基本的验证方法
     *
     *  @param regEx 校验格式
     *  @param data  要校验的数据
     *
     *  @return true:成功 false:失败
     */
    func baseCheckForRegEx(_ regEx : String, _ data : String) -> Bool{
        
        let card = NSPredicate(format: "SELF MATCHES %@", regEx)
        if card.evaluate(with: data) {
            return true
        }
        return false
    }
}
