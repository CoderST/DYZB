//
//  IPhoneButton.swift
//  DYZB
//
//  Created by xiudou on 2017/7/19.
//  Copyright © 2017年 xiudo. All rights reserved.
//  左边文字右边图片

import UIKit

class IPhoneButton: UIButton {

    override var isHighlighted: Bool{
        get{
            return false
        }
        set{
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // MARK: - 设置视图
    private func setupUI(){
        // 设置imageView
        imageView?.contentMode = .center
        // 设置tilte
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        setTitleColor(.darkGray, for: .normal)
    }
    
    // 对其子控件重新布局
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置title
        titleLabel?.frame = CGRect(x: 0, y: 0, width: frame.width * 0.5, height: frame.height)
        // 设置imageView
        imageView?.frame = CGRect(x: frame.width * 0.5, y: 0, width: frame.width * 0.5, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
