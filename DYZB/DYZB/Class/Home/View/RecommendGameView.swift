//
//  RecommendGameView.swift
//  DYZB
//
//  Created by xiudou on 16/9/24.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class RecommendGameView: UIView {


    override func awakeFromNib() {
        backgroundColor = UIColor.greenColor()
    }

}

// MARK:- 快速创建对象
extension RecommendGameView{
    
    class func creatRecommendGameView()->RecommendGameView{
        
        return NSBundle.mainBundle().loadNibNamed("RecommendGameView", owner: nil, options: nil).first as!RecommendGameView
    }
}
