//
//  ShowUserView.swift
//  DYZB
//
//  Created by xiudou on 16/11/9.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
// nickNameLabel
private let reportButtonFontSize : CGFloat = 15
private let nickNameLabelFontSize : CGFloat = 14
private let iconImageViewWH : CGFloat = 70
private let ediMargin : CGFloat = 15
protocol ShowUserViewDelegate : NSObjectProtocol{
    
    func showUserViewCloseVC(_ showUserView : ShowUserView)
}

class ShowUserView: UIView {
    
    weak var delegate : ShowUserViewDelegate?
    
    // MARK:- SET
    var userModel : RoomFollowPerson?{
        
        didSet{
            
            guard let model = userModel else { return }
            
            iconImageView.sd_setImage(with: URL(string: model.photo ), placeholderImage: UIImage(named: "placeholder_head"), options: .refreshCached) { (image, error, cacheType, url) in
                    if error == nil{
                        if let safeImage = image{
    
                            let image = UIImage.circleImage(safeImage, borderColor: UIColor.white, borderWidth: 1)
                            self.iconImageView.image = image
                        }
                    }

            }
            
            nickNameLabel.text = model.nickname 
            
            
        }
    }
    
    // MARK:- 懒加载
    // 举报
    fileprivate lazy var reportButton : UIButton = {
        let reportButton = UIButton()
        reportButton.setTitle("举报", for: UIControlState())
        reportButton.setTitleColor(UIColor.black, for: UIControlState())
        reportButton.titleLabel?.font = UIFont.systemFont(ofSize: reportButtonFontSize)
        reportButton.addTarget(self, action: #selector(ShowUserView.reportButtonClick), for: .touchUpInside)
        return reportButton
        
    }()
    
    // 关闭
    fileprivate lazy var closeButton : UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "user_close_15x15"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(ShowUserView.closeButtonClick), for: .touchUpInside)
        return closeButton
        
    }()
    
    // 中间包裹的view
    fileprivate lazy var centerCoverView : UIView = {
        let centerCoverView = UIView()
        return centerCoverView
        
    }()
    
    //  用户头像
    fileprivate lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
        
    }()
    
    // 用户名称
    fileprivate lazy var nickNameLabel : UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.textColor = UIColor.black
        nickNameLabel.font = UIFont.systemFont(ofSize: nickNameLabelFontSize)
        return nickNameLabel
        
    }()
    
    
    
    // MARK:- LIFE
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        let manage = SDWebImageManager.shared()
        manage?.cancelAll()
    }
    
}

// MARK:- UI布局
extension ShowUserView {
    
    func setupUI(){
        
        addSubview(reportButton)
        addSubview(closeButton)
        
        addSubview(centerCoverView)
        centerCoverView.addSubview(iconImageView)
        centerCoverView.addSubview(nickNameLabel)
        
        reportButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(20)
            make.left.equalTo(30)
        }
        
        closeButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(reportButton)
            make.right.equalTo(-30)
        }
        
        centerCoverView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(reportButton.snp.bottom).offset(10)
            make.left.equalTo(ediMargin)
            make.right.equalTo(-ediMargin)
            make.bottom.equalTo(self)
        }
        
        iconImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(ediMargin)
            make.centerX.equalTo(centerCoverView)
            make.width.height.equalTo(iconImageViewWH)
        }
        
        nickNameLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(iconImageView)
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
        }
        
        
    }
}

// MARK:- 按钮点击事件
extension ShowUserView {
    @objc fileprivate func reportButtonClick(){
    }
    
    @objc fileprivate func closeButtonClick(){
        delegate?.showUserViewCloseVC(self)
    }
    
}
