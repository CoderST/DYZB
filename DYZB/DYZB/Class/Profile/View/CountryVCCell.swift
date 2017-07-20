//
//  CountryVCCell.swift
//  DYZB
//
//  Created by xiudou on 2017/7/18.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class CountryVCCell: UICollectionViewCell {
    
    fileprivate let titleLabel : UILabel = {
        let titleLabel = UILabel()
//        titleLabel.backgroundColor = UIColor.red
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
        
    }()
    
    fileprivate let subTitleLabel : UILabel = {
        let subTitleLabel = UILabel()
//        subTitleLabel.backgroundColor = UIColor.blue
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        return subTitleLabel
        
    }()
    
    fileprivate let lineView : UIView = {
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        return lineView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(lineView)
    }
    
    var countryModel : CountryModel?{
        
        didSet{
            
            guard let countryModel = countryModel else { return }
            
            titleLabel.text = countryModel.country
            
            subTitleLabel.text = countryModel.mobile_prefix
            
            let titleSize = countryModel.country.sizeWithFont(titleLabel.font)
            
            titleLabel.frame = CGRect(x: 20, y: 0, width: titleSize.width, height: frame.height)
            
            let subTitleSize = countryModel.mobile_prefix.sizeWithFont(subTitleLabel.font)
            
            subTitleLabel.frame = CGRect(x: frame.width - subTitleSize.width - 20, y: 0, width: subTitleSize.width, height: frame.height)
            
            lineView.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
            
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
