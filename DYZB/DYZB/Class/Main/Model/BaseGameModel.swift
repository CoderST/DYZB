//
//  BaseGameModel.swift
//  DYZB
//
//  Created by xiudou on 16/10/26.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class BaseGameModel: BaseModel {
    // MARK:- 定义属性
    var tag_name : String = ""
    var icon_url : String = ""
    var tag_id : String = ""

    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "tag_id" {
            if value is Int { // Int
                guard let tag_idInt = value as? Int else { return }
                let tag_idString = "\(tag_idInt)"
                tag_id = tag_idString
            }else{  // String
                guard let tag_idString = value as? String else { return }
                tag_id = tag_idString

            }
        }else {
            super.setValue(value, forKey: key)
        }
    }
}
