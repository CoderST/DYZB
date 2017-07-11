//
//  User.swift
//  DYZB
//
//  Created by xiudou on 2017/6/21.
//  Copyright © 2017年 xiudo. All rights reserved.
//  网络用户数据

import UIKit

class User: BaseModel {
    var uid : String = ""
    var username : String = ""
    var nickname : String = ""
    var email : String = ""
    var mobile_phone : String = ""
    var phone_status : String = ""
    var email_status : String = ""
    var lastlogin : String = ""
    var has_room : String = ""
    var groupid : String = ""
    var is_own_room : String = ""
    var sex : String = ""
    var birthday : String = ""
    var gold1 : String = ""
    var score : String = ""
    var follow : String = ""
    var gold : String = ""
    var noble_gold : String = ""
    var ident_status : String = ""
    var qq : String = ""
    
    var avatar : Avatar?
    var location : Location?
    var userlevel : Userlevel?
    
    // MARK:- 必须调用super 不能省略
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "avatar"{
            if let dict = value as? [String : Any] {
                
                avatar = Avatar(dict: dict)
            }
        }else if key == "location"{
            if let dict = value as? [String : Any] {
                
                location = Location(dict: dict)
            }
            
        }else if key == "userlevel" {
            if let dict = value as? [String : Any] {
                
                userlevel = Userlevel(dict: dict)
            }
            
        }else if key == "email"{
            if let value = value as? Bool {
          
            }else{
                if let value = value as? String{
                    
                    email = value
                }
            }
        }
        
        
        else{
            
            super.setValue(value, forKey: key)
        }
        
    }
}


class Avatar: BaseModel {
    
    var small : String = ""
    var middle : String = ""
    var big : String = ""
    
}

class Location: BaseModel {
    var province : String = ""
    var city : String = ""
}

class Userlevel: BaseModel {
    var cur_score : Int = 0
    var next_level_score : Int = 0
    var lv : Int = 0
    var is_full : Int = 0
    
}
