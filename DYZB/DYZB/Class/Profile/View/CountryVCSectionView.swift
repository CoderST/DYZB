//
//  CountryVCSectionView.swift
//  DYZB
//
//  Created by xiudou on 2017/7/18.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class CountryVCSectionView: UICollectionReusableView {
    
    fileprivate let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
    }
    
    var title : String?{
        
        didSet{
            
            guard let title = title else { return }
            titleLabel.text = title
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 5, y: 0, width: sScreenW, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
