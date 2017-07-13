//
//  STCollectionViewCell.swift
//  DYZB
//
//  Created by xiudou on 2017/7/13.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate var margin : CGFloat = 20
fileprivate let arrowImageViewWH : CGFloat = 20
class STCollectionViewCell: UICollectionViewCell {

    
    lazy var titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
        
    }()

    lazy var lineView : UIView = {
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        return lineView
        
    }()
    
     lazy var arrowImageView : UIImageView = {
        
        let arrowImageView = UIImageView()
        arrowImageView.contentMode = .center
        arrowImageView.image = UIImage(named: "Image_arrow_right")
        return arrowImageView
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(arrowImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

       
        titleLabel.sizeToFit()
        let size = titleLabel.text!.sizeWithFont(UIFont.systemFont(ofSize: 14), size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
        titleLabel.frame = CGRect(x: margin, y: 0, width: size.width, height: frame.height)

        arrowImageView.frame = CGRect(x: frame.width - arrowImageViewWH - margin, y: 0, width: arrowImageViewWH, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
