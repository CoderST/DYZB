//
//  LocationReusableView.swift
//  DYZB
//
//  Created by xiudou on 2017/7/14.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class LocationReusableView: UICollectionReusableView {
 
    fileprivate let titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
    }
    
    var titleString : String?{
        
        didSet{
            
            guard let titleString = titleString else { return }
            
            titleLabel.text = titleString
            titleLabel.sizeToFit()
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 20, y: 0, width: titleLabel.frame.width, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
