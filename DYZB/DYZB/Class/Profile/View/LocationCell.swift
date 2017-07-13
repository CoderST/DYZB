//
//  LocationCell.swift
//  DYZB
//
//  Created by xiudou on 2017/7/12.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate var margin : CGFloat = 20
fileprivate let arrowImageViewWH : CGFloat = 20
/// 定义代理
protocol LocationCellDelegate : class{
    /// 左边标题
    func locationCellTitleLabelString(locationCell : LocationCell)->String
    /// 右边的箭头
    func locationCellArrowImageViewString(locationCell : LocationCell)->String
    /// 底部的线
    func locationCellLineView(locationCell : LocationCell)->Bool
}


class LocationCell: UICollectionViewCell {
    
    weak var delegate : LocationCellDelegate?
    
    
    fileprivate lazy var titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()
    
    fileprivate let lineView : UIView = {
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        return lineView
        
    }()
    
    fileprivate let arrowImageView : UIImageView = {
        
        let arrowImageView = UIImageView()
        arrowImageView.contentMode = .center
        // Image_arrow_right
        return arrowImageView
        
    }()
    
//    var locationModel : LocationModel?{
//        
//        didSet{
//            
//            guard let locationModel = locationModel else { return }
//            titleLabel.text = locationModel.State
//            titleLabel.sizeToFit()
//            // 判断是否添加箭头
//            arrowImageView.isHidden = !(locationModel.Cities.count > 0)
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        
            contentView.addSubview(titleLabel)
        
        
            contentView.addSubview(lineView)
        
        
            contentView.addSubview(arrowImageView)

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let titleString = delegate?.locationCellTitleLabelString(locationCell: self){
            titleLabel.text = titleString
            titleLabel.sizeToFit()
            
            titleLabel.frame = CGRect(x: margin, y: 0, width: titleLabel.frame.width, height: frame.height)
        }
        
        if let arrowImageViewString = delegate?.locationCellArrowImageViewString(locationCell: self){
            arrowImageView.image = UIImage(named: arrowImageViewString)
            
            arrowImageView.frame = CGRect(x: frame.width - arrowImageViewWH - 10, y: 0, width: arrowImageViewWH, height: frame.height)
        }
        
        
        if let isLineView = delegate?.locationCellLineView(locationCell: self){
            
            if isLineView{
                lineView.isHidden = false
                lineView.frame = CGRect(x: 0, y: frame.height - 1, width: sScreenW, height: 1)
            }else{
                lineView.isHidden = true
            }
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
