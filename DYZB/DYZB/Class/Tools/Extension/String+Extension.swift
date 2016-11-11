//
//  String+Extension.swift
//  DYZB
//
//  Created by xiudou on 16/11/8.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

extension String{
    
    /**
     或者文本宽高
     
     - parameter font: 字体
     - parameter size: 显示的尺寸
     
     - returns: size
     */
     func sizeWithFont(font:UIFont,size:CGSize) -> CGSize {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        let size = self.boundingRectWithSize(size, options: option, attributes: attributes, context: nil).size
        return size;
    }

    
}
