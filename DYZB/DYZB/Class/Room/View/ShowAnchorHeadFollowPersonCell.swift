//
//  ShowAnchorHeadFollowPersonCell.swift
//  DYZB
//
//  Created by xiudou on 16/11/8.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import SDWebImage
// MARK:- 常量
private let iconImageViewWH :CGFloat = 30

class ShowAnchorHeadFollowPersonCell: UICollectionViewCell {

    // MARK:- 懒加载
    fileprivate lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.frame = CGRect(x: 0, y: 0, width: iconImageViewWH, height: iconImageViewWH)
        return iconImageView
    }()
  
    // MARK:- SET
    var roomFollowPerson : RoomFollowPerson?{
        
        didSet{
            
            guard let model = roomFollowPerson else { return }
            iconImageView.sd_setImage(with: URL(string: model.photo), placeholderImage: UIImage(named: "placeholder_head"))
        }
    }
    
    // MARK:- 系统回调
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconImageView)
        
        iconImageView.layer.cornerRadius = iconImageViewWH * 0.5
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderWidth = 5
        iconImageView.layer.borderColor = UIColor.green.cgColor
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
