//
//  DownButton.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class DownButton: UIButton {

    init(frame: CGRect, title : String, backGroundColor : UIColor?, font : UIFont, cornerRadius : CGFloat? = 0) {
        super.init(frame: frame)
        
        backgroundColor = backGroundColor
        setTitle(title, for: .normal)
        titleLabel?.font = font
        layer.cornerRadius = cornerRadius ?? 0
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
