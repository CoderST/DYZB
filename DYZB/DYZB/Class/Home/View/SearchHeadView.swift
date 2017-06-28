//
//  SearchHeadView.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let dissmissButtonWH : CGFloat = 50
fileprivate let lineViewHeight : CGFloat = 1
class SearchHeadView: UIView {

    fileprivate lazy var dissmissButton : UIButton = {
        
        let dissmissButton = UIButton()
        dissmissButton.setTitle("取消", for: .normal)
        dissmissButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize)
        dissmissButton.setTitleColor(.orange, for: .normal)
        return dissmissButton
    }()
    
    fileprivate lazy var lineView : UIView = {
       
        let lineView = UIView()
        lineView.backgroundColor = .gray
        return lineView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(dissmissButton)
        
        dissmissButton.addTarget(self, action: #selector(dissmissButtonClick), for: .touchUpInside)
    }
    
    @objc fileprivate func dissmissButtonClick() {
        notificationCenter.post(name: Notification.Name(rawValue: sNotificationName_Dismiss), object: nil, userInfo: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dissmissButton.frame = CGRect(x: frame.width - dissmissButtonWH - 10, y: 0, width: dissmissButtonWH, height: frame.height)
        
        lineView.frame = CGRect(x: 0, y: frame.height - lineViewHeight, width: frame.width, height: lineViewHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


