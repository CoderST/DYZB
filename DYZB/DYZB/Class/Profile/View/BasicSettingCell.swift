//
//  BasicSettingCell.swift
//  DYZB
//
//  Created by xiudou on 2017/7/10.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let settingMargin : CGFloat = 20
fileprivate let rightImageViewWH : CGFloat = 40
class BasicSettingCell: UICollectionViewCell {
    
    fileprivate lazy var leftImageView : UIImageView = {
        
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "")
        return leftImageView
    }()
    
    fileprivate lazy var titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
    }()
    
    fileprivate lazy var subTitleLabel : UILabel = {
        
        let subTitleLabel = UILabel()
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        return subTitleLabel
    }()
    
    fileprivate lazy var arrowView : UIImageView = {
        
        let arrowView = UIImageView()
        arrowView.image = UIImage(named: "Image_arrow_right")
        return arrowView
    }()
    
    fileprivate lazy var rightImageView : UIImageView = {
        
        let rightImageView = UIImageView()
        return rightImageView
    }()
    
    fileprivate lazy var bottomLineView : UIView = {
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = .gray
        return bottomLineView
    }()
    
    
    var accessoryView : UIView?
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        contentView.backgroundColor = .white
        contentView.addSubview(arrowView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(rightImageView)
        contentView.addSubview(bottomLineView)
    }
    
    // 根据settingItem模型来显示内容
    var settingItemFrame : SettingItemFrame?{
        
        didSet{
            guard let settingItemFrame = settingItemFrame else { return }
            
            setupData(settingItemFrame)
            
            setupFrame(settingItemFrame)
        }
    }
    
    // 设置每一组的背景图片的方法
    func setIndexPath(indexPath : NSIndexPath,rowCount : NSInteger){
        
    }
    
    func setupData(_ settingItemFrame : SettingItemFrame){
        
        leftImageView.image = UIImage(named: settingItemFrame.settingItem.icon!)
        titleLabel.text = settingItemFrame.settingItem.title
        subTitleLabel.text = settingItemFrame.settingItem.subTitle
        
        
        if settingItemFrame.settingItem is ArrowImageItem{
            let arroeImageItem = settingItemFrame.settingItem as!ArrowImageItem
            if let url = URL(string: arroeImageItem.rightImageName){
                rightImageView.sd_setImage(with: url, placeholderImage: UIImage(named : "profile_user_375x375"), options: .allowInvalidSSLCertificates)
            }
            
        }
    }

    
    func setupFrame(_ settingItemFrame : SettingItemFrame){

        leftImageView.frame = settingItemFrame.iconImageViewFrame
        titleLabel.frame = settingItemFrame.titleFrame
        subTitleLabel.frame = settingItemFrame.subTitleFrame
        rightImageView.frame = settingItemFrame.headImageViewFrame
        arrowView.frame = settingItemFrame.arrowFrame
        bottomLineView.frame = settingItemFrame.bottomLineFrame
        
        rightImageView.layer.cornerRadius = settingItemFrame.headImageViewFrame.width * 0.5
        rightImageView.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
