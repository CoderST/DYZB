//
//  ProfileHeadView.swift
//  DYZB
//
//  Created by xiudou on 2017/6/19.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let verticalButtonWidth : CGFloat = sScreenW / 4
class ProfileHeadView: UIView {

    fileprivate let backgroundImageView : UIImageView = {
        
        let backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .center
        backgroundImageView.image = UIImage(named: "Image_userView_background")
        return backgroundImageView
        
    }()
    
    fileprivate let historyButton : VerticalButton = VerticalButton()
    
    fileprivate let mailButton : VerticalButton = VerticalButton()
    
    fileprivate let taskButton : VerticalButton = VerticalButton()
    
    fileprivate let rechargeButton : VerticalButton = VerticalButton()
    
    fileprivate func setupVerticalButton(button : VerticalButton, imageNamed : String, title : String){
        button.setImage(UIImage(named : imageNamed), for: .normal)
        button.setTitle(title, for: .normal)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        
        addSubview(historyButton)
        addSubview(mailButton)
        addSubview(taskButton)
        addSubview(rechargeButton)
        
        setupVerticalButton(button: historyButton, imageNamed: "btn_my_mail", title: "观看历史")
        setupVerticalButton(button: mailButton, imageNamed: "btn_my_mail", title: "站内信")
        setupVerticalButton(button: taskButton, imageNamed: "btn_my_mail", title: "我的任务")
        setupVerticalButton(button: rechargeButton, imageNamed: "btn_my_mail", title: "鱼翅充值")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var backgroundImageViewHeight : CGFloat = 0
        if let imagesize = backgroundImageView.image?.size{
            backgroundImageView.frame = CGRect(x: 0, y: 0, width: imagesize.width, height: imagesize.height)
            backgroundImageViewHeight = imagesize.height
        }else{
            backgroundImageView.frame = CGRect(x: 0, y: 0, width: sScreenW, height: 200)
            backgroundImageViewHeight = 200
        }
        
        historyButton.frame = CGRect(x: 0, y: backgroundImageView.frame.maxY, width: verticalButtonWidth, height: frame.height - backgroundImageViewHeight)
        
        mailButton.frame = CGRect(x: historyButton.frame.maxX, y: backgroundImageView.frame.maxY, width: verticalButtonWidth, height: historyButton.frame.height)
        
        taskButton.frame = CGRect(x: mailButton.frame.maxX, y: backgroundImageView.frame.maxY, width: verticalButtonWidth, height: historyButton.frame.height)
        
        rechargeButton.frame = CGRect(x: taskButton.frame.maxX, y: backgroundImageView.frame.maxY, width: verticalButtonWidth, height: historyButton.frame.height)
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileHeadView {
    
    fileprivate func setupCustomButton() {
        
        // 历史
        
        // 信
        // 任务
        // 充值
    }
}
