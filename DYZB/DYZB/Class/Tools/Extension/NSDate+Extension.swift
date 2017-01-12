//
//  NSDate+Extension.swift
//  DYZB
//
//  Created by xiudou on 16/9/20.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

extension Date{
    
    static func getNowDate() ->String{
        let date = Date()
        
        let time = Int(date.timeIntervalSince1970)
        
        return "\(time)"
    }
}
