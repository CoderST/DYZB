//
//  ShowAnchorHeadFollowPersonCell.swift
//  DYZB
//
//  Created by xiudou on 16/11/8.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

// MARK:- 常量
private let iconImageViewWH :CGFloat = 30

class ShowAnchorHeadFollowPersonCell: UICollectionViewCell {

    // MARK:- 懒加载
    private lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.frame = CGRect(x: 0, y: 0, width: iconImageViewWH, height: iconImageViewWH)
        return iconImageView
    }()
  
    // MARK:- SET
    var roomFollowPerson : RoomFollowPerson?{
        
        didSet{
            
            guard let model = roomFollowPerson else { return }
            
            iconImageView.sd_setImageWithURL(NSURL(string: model.photo), placeholderImage: UIImage(named: "placeholder_head"))
            
        }
    }
    
    // MARK:- 系统回调
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconImageView)
        
        iconImageView.layer.cornerRadius = iconImageViewWH * 0.5
        iconImageView.clipsToBounds = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
