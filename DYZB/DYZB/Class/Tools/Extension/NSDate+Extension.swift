//
//  NSDate+Extension.swift
//  DYZB
//
//  Created by xiudou on 16/9/20.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

extension NSDate{
    
    class func getNowDate() ->String{
        let date = NSDate()
        
        let time = Int(date.timeIntervalSince1970)
        
        return "\(time)"
    }
}
