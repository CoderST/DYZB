//
//  QQTextField.swift
//  DYZB
//
//  Created by xiudou on 2017/7/24.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class QQTextField: UITextField {

    //控制显示文本的位置
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        
//        let rect = CGRect(x: bounds.origin.x + 10, y:  bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
//        
//        return rect
//    }
    
    //控制placeHolder的位置
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(x: bounds.origin.x + 5, y:  bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
        
        return rect
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = CGRect(x: bounds.origin.x + 5, y:  bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
        
        return rect
    }

}
