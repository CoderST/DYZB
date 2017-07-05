//
//  ProfileHeadView.swift
//  DYZB
//
//  Created by xiudou on 2017/6/19.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let verticalButtonWidth : CGFloat = sScreenW / 4
fileprivate let userIconImageViewHW : CGFloat = 80
class ProfileHeadView: UIView {

    fileprivate lazy var backgroundImageView : UIImageView = {
        
        let backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .center
        backgroundImageView.image = UIImage(named: "Image_userView_background")
        return backgroundImageView
        
    }()
    
    fileprivate lazy var userIconImageView : UserIconView = {
        
        let userIconImageView = UserIconView()
        
        return userIconImageView
    }()
    
    fileprivate lazy var userNameLabel : UILabel = {
       
        let userNameLabel = UILabel()
        userNameLabel.textColor = UIColor.white
        userNameLabel.font = UIFont.systemFont(ofSize: 12)
        return userNameLabel
        
    }()
    
    fileprivate lazy var historyButton : VerticalButton = VerticalButton()
    
    fileprivate lazy var mailButton : VerticalButton = VerticalButton()
    
    fileprivate lazy var taskButton : VerticalButton = VerticalButton()
    
    fileprivate lazy var rechargeButton : VerticalButton = VerticalButton()
    
    fileprivate func setupVerticalButton(button : VerticalButton, imageNamed : String, title : String){
        button.setImage(UIImage(named : imageNamed), for: .normal)
        button.setTitle(title, for: .normal)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(r: 239, g: 239, b: 239)
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(userIconImageView)
        
        addSubview(historyButton)
        addSubview(mailButton)
        addSubview(taskButton)
        addSubview(rechargeButton)
        
        historyButton.setTitleColor(.black, for: .normal)
        mailButton.setTitleColor(.black, for: .normal)
        taskButton.setTitleColor(.black, for: .normal)
        rechargeButton.setTitleColor(.black, for: .normal)
        
        historyButton.backgroundColor = .white
        mailButton.backgroundColor = .white
        taskButton.backgroundColor = .white
        rechargeButton.backgroundColor = .white
        
        setupVerticalButton(button: historyButton, imageNamed: "btn_my_mail", title: "观看历史")
        setupVerticalButton(button: mailButton, imageNamed: "btn_my_mail", title: "站内信")
        setupVerticalButton(button: taskButton, imageNamed: "btn_my_mail", title: "我的任务")
        setupVerticalButton(button: rechargeButton, imageNamed: "btn_my_mail", title: "鱼翅充值")
        
        historyButton.addTarget(self, action: #selector(historyButtonAction), for: .touchUpInside)
        mailButton.addTarget(self, action: #selector(mailButtonAction), for: .touchUpInside)
        taskButton.addTarget(self, action: #selector(taskButtonAction), for: .touchUpInside)
        rechargeButton.addTarget(self, action: #selector(rechargeButtonAction), for: .touchUpInside)
    }

    var user : User?{
        
        didSet{
            guard let user = user else { return }
            guard let imageName = user.avatar?["small"] else { return }
            userIconImageView.imageName = imageName
            userNameLabel.text = user.nickname
        }
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
        
        
        userIconImageView.frame = CGRect(x: 15, y: backgroundImageView.frame.height - userIconImageViewHW - 20, width: userIconImageViewHW, height: userIconImageViewHW)
        if let nickName = user?.nickname{
            let userNameLabelSize = nickName.sizeWithFont(userNameLabel.font, size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
            userNameLabel.frame = CGRect(x: userIconImageView.frame.maxX + 10, y: userIconImageView.frame.origin.x + 10, width: userNameLabelSize.width, height: userNameLabelSize.height)
        }
        
        
        historyButton.frame = CGRect(x: 0, y: backgroundImageView.frame.maxY, width: verticalButtonWidth, height: frame.height - backgroundImageViewHeight - 10)
        
        mailButton.frame = CGRect(x: historyButton.frame.maxX, y: backgroundImageView.frame.maxY, width: verticalButtonWidth, height: historyButton.frame.height)
        
        taskButton.frame = CGRect(x: mailButton.frame.maxX, y: backgroundImageView.frame.maxY, width: verticalButtonWidth, height: historyButton.frame.height)
        
        rechargeButton.frame = CGRect(x: taskButton.frame.maxX, y: backgroundImageView.frame.maxY, width: verticalButtonWidth, height: historyButton.frame.height)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 按钮点击事件
extension ProfileHeadView {
    
    @objc fileprivate  func historyButtonAction(){
        let nav = getNavigation()
        let historyVC = WatchHistoryViewController()
        
        nav.pushViewController(historyVC, animated: true)
        

    }
    
    @objc fileprivate  func mailButtonAction(){
        let nav = getNavigation()
        let interalMessageVC = InteralMessageViewController()
        
        nav.pushViewController(interalMessageVC, animated: true)
    }
    
    @objc fileprivate  func taskButtonAction(){

        let nav = getNavigation()
        let myTaskVM = MyTaskViewController()
        
        nav.pushViewController(myTaskVM, animated: true)

    }
    
    @objc fileprivate  func rechargeButtonAction(){
        let fishboneRecharge = FishboneRechargeViewController()
        let nav = getNavigation()
        nav.pushViewController(fishboneRecharge, animated: true)
    }
    
    fileprivate func getNavigation()->MainNavigationController{
        let tabVC = window?.rootViewController as!UITabBarController
        let nav = tabVC.selectedViewController as!MainNavigationController
        
        return nav
    }

}
