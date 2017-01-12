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
    
    convenience init(imageName:String,highImageName:String = "",size:CGSize = CGSize.zero) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControlState())
        if (highImageName != ""){
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
            
        }
        
        if (size == CGSize.zero){
            btn.sizeToFit()
        }else{
            
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        self.init(customView:btn)
    }
}
