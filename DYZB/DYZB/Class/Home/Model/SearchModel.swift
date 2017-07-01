//
//  SearchModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class SearchModel: NSObject {

    var title : String = ""
    var rank : Int = 0
    
    init(title : String, rank : Int) {
        super.init()
//        setValuesForKeys(dict)
        self.title = title
        self.rank = rank
    }
    
    
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        
//    }
}
