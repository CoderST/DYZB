//
//  VerticalButton.swift
//  DYZB
//
//  Created by xiudou on 2017/6/20.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
class VerticalButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView?.contentMode = .center
        titleLabel?.textAlignment = .center
//        titleLabel?.textColor = .black
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height * 2 / 3)
        titleLabel?.frame =  CGRect(x: 0, y: frame.height * 2 / 3, width: frame.width, height: frame.height * 1 / 3)
    }

}
