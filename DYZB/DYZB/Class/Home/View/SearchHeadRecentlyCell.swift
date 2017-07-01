//
//  SearchHeadCell.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//  最近搜索cell

import UIKit

class SearchHeadRecentlyCell: UICollectionViewCell {
 
    
    fileprivate let titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: titleFontSize)
        titleLabel.textAlignment = .center
        return titleLabel
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.lightGray
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        contentView.addSubview(titleLabel)
    }
    
    var searchFrame : SearchModelFrame?{
        
        didSet{
            guard let searchFrame = searchFrame else { return }
            
            titleLabel.text = searchFrame.searchModel.title
            
            titleLabel.frame = CGRect(x: 0, y: 0, width: searchFrame.cellSize.width, height: searchFrame.cellSize.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
