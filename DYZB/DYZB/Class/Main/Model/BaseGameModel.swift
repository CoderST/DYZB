//
//  BaseGameModel.swift
//  DYZB
//
//  Created by xiudou on 16/10/26.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class BaseGameModel: NSObject {
    // MARK:- 定义属性
    var tag_name : String = ""
    var icon_url : String = ""
    
    override init() {
        
    }
    
    init(dic:[String : AnyObject]){
        super.init()
        
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
