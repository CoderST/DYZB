//
//  SearchModelFrame.swift
//  DYZB
//
//  Created by xiudou on 2017/6/27.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
let titleFontSize : CGFloat = 12
let searchModelMargin : CGFloat = 10 // 上下左右间隙
class SearchModelFrame: NSObject {

    var searchModel : SearchModel
    
    var cellSize : CGSize = CGSize.zero
    
    init(_ searchModel : SearchModel) {
        self.searchModel =  searchModel
        super.init()
        
        let title = searchModel.title
        let size = title.sizeWithFont(UIFont.systemFont(ofSize: titleFontSize), size: CGSize(width: CGFloat(MAXFLOAT), height: titleFontSize + 3))
        cellSize = CGSize(width: size.width + 2 * searchModelMargin, height: size.height + 2 * searchModelMargin)
    }
}
