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
    
    func showUserViewCloseVC(showUserView : ShowUserView)
}

class ShowUserView: UIView {
    
    
    
    weak var delegate : ShowUserViewDelegate?
    
    // MARK:- SET
    var userModel : RoomFollowPerson?{
        
        didSet{
            
            guard let model = userModel else { return }
            iconImageView.image = UIImage(named: "placeholder_head")
            let sdDownloader = SDWebImageDownloader.sharedDownloader()
            sdDownloader.downloadImageWithURL(NSURL(string: model.photo ?? ""), options: SDWebImageDownloaderOptions.UseNSURLCache, progress: nil) { [weak self](downLoadImage : UIImage!, data : NSData!, error : NSError!, finished : Bool) -> Void in
                
                if finished{
                    // 回主线程刷新UI
                    dispatch_async(dispatch_get_main_queue()) {
                        let resultImage = UIImage.circleImage(downLoadImage, borderColor: UIColor.redColor(), borderWidth: 1.0)
                        self?.iconImageView.image = resultImage
                        
                    }
                }
            }
            
            nickNameLabel.text = model.nickname ?? ""
            
            
        }
    }
    
    // MARK:- 懒加载
    // 举报
    private lazy var reportButton : UIButton = {
        let reportButton = UIButton()
        reportButton.setTitle("举报", forState: .Normal)
        reportButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        reportButton.titleLabel?.font = UIFont.systemFontOfSize(reportButtonFontSize)
        reportButton.addTarget(self, action: "reportButtonClick", forControlEvents: .TouchUpInside)
        return reportButton
        
    }()
    
    // 关闭
    private lazy var closeButton : UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "user_close_15x15"), forState: .Normal)
        closeButton.addTarget(self, action: "closeButtonClick", forControlEvents: .TouchUpInside)
        return closeButton
        
    }()
    
    // 中间包裹的view
    private lazy var centerCoverView : UIView = {
        let centerCoverView = UIView()
        return centerCoverView
        
    }()
    
    //  用户头像
    private lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
        
    }()
    
    // 用户名称
    private lazy var nickNameLabel : UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.textColor = UIColor.blackColor()
        nickNameLabel.font = UIFont.systemFontOfSize(nickNameLabelFontSize)
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
        let manage = SDWebImageManager.sharedManager()
        manage.cancelAll()
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
        
        reportButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(20)
            make.left.equalTo(30)
        }
        
        closeButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(reportButton)
            make.right.equalTo(-30)
        }
        
        centerCoverView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(reportButton.snp_bottom).offset(10)
            make.left.equalTo(ediMargin)
            make.right.equalTo(-ediMargin)
            make.bottom.equalTo(self)
        }
        
        iconImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(ediMargin)
            make.centerX.equalTo(centerCoverView)
            make.width.height.equalTo(iconImageViewWH)
        }
        
        nickNameLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(iconImageView)
            make.top.equalTo(iconImageView.snp_bottom).offset(10)
        }
        
        
    }
}

// MARK:- 按钮点击事件
extension ShowUserView {
    @objc private func reportButtonClick(){
    }
    
    @objc private func closeButtonClick(){
        delegate?.showUserViewCloseVC(self)
    }
    
}
