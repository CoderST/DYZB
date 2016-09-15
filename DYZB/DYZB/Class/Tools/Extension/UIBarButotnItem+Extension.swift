//
//  UIBarButotnItem+Extension.swift
//  DYZB
//
//  Created by xiudou on 16/9/15.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    // MARK:- 构造函数
    
    convenience init(imageName:String,highImageName:String = "",size:CGSize = CGSizeZero) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        if (highImageName != ""){
            btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
            
        }
        
        if (size == CGSizeZero){
            btn.sizeToFit()
        }else{
            
            btn.frame = CGRect(origin: CGPointZero, size: size)
        }
        
        self.init(customView:btn)
    }
}