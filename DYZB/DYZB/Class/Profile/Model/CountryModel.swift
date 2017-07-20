//
//  CountryModel.swift
//  DYZB
//
//  Created by xiudou on 2017/7/17.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class CountryModel: BaseModel {

    var country : String = ""
    var mobile_prefix : String = ""
    var country_letter : String = ""
    
//    override func setValue(_ value: Any?, forKey key: String) {
//        if key == "mobile_prefix" {
//            guard let val = value as? String else { return }
//            let valadd = "+\(val)"
//            mobile_prefix = valadd
//        }else{
//            
//            super.setValue(value, forKey: key)
//        }
//    }
}
