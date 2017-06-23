//
//  SearchHeadModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class SearchHeadModel: NSObject {

    var title : String = ""
    var subTitle : String = ""
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
}
