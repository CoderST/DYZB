//
//  InteralMessageModel.swift
//  DYZB
//
//  Created by xiudou on 2017/7/3.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class InteralMessageModel: NSObject {

    var id : String = ""
    var status : String = ""
    var sub : String = ""
    var body : String = ""
    var ts : String = ""
    var src_nickname : String = ""
    var avatar : String = ""
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
