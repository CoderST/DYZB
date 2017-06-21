//
//  ProfileCell.swift
//  DYZB
//
//  Created by xiudou on 2017/6/20.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let margin : CGFloat = 20
fileprivate let iconImageViewHW : CGFloat = 20
class ProfileCell: UICollectionViewCell {
    
    fileprivate let lineView : UIView = {
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        return lineView
        
    }()
    
    fileprivate let iconImageView : UIImageView = {
        
        let iconImageView = UIImageView()
        iconImageView.contentMode = .center
        return iconImageView
        
    }()
    
    fileprivate let titleLabel : UILabel = {
       
        let titleLabel = UILabel()
        
        return titleLabel
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var profileModel : ProfileModel?{
        
        didSet{
            guard let profileModel = profileModel else { return }
            iconImageView.image = UIImage(named: profileModel.imageName)
            titleLabel.text = profileModel.titleName
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(x: margin, y: 0, width: iconImageViewHW, height: frame.height)
        titleLabel.frame = CGRect(x: iconImageView.frame.maxX + 10, y: 0, width: 100, height: frame.height)
        lineView.frame = CGRect(x: margin, y: frame.height - 1, width: sScreenW - margin, height: 1)
    }
}
