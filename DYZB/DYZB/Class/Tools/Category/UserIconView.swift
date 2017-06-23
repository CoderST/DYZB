//
//  UserIconView.swift
//  DYZB
//
//  Created by xiudou on 2017/6/21.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import SDWebImage
class UserIconView: UIView {
    
    fileprivate lazy var iconImageView : UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "avatar_placeholder")
        return iconImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        
        addSubview(iconImageView)
    }
    
    
    var imageName : String?{
        
        didSet{
           
            guard let imageName = imageName else { return }
            guard let url = URL(string: imageName) else { return }
            iconImageView.sd_setImage(with: url, placeholderImage:  UIImage(named: "avatar_placeholder"), options: .allowInvalidSSLCertificates)
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width * 0.5
        clipsToBounds = true
        iconImageView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
