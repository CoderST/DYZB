//
//  ProfileInforCell.swift
//  DYZB
//
//  Created by xiudou on 2017/7/10.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let iconImageViewWH : CGFloat = 30
fileprivate let arrowImageViewWH : CGFloat = 20
class ProfileInforCell: UICollectionViewCell {
    
    fileprivate let titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        
        return titleLabel
        
    }()
    
    fileprivate let subTitleLabel : UILabel = {
        
        let subTitleLabel = UILabel()
        
        return subTitleLabel
        
    }()
    
    fileprivate let iconImageView : UIImageView = {
        
        let iconImageView = UIImageView()
        iconImageView.contentMode = .center
        return iconImageView
        
    }()
    
    fileprivate let arrowImageView : UIImageView = {
        
        let arrowImageView = UIImageView()
        arrowImageView.contentMode = .center
        return arrowImageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(arrowImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    var baseCellModel : BaseCellModel?{
//        
//        didSet{
//            
//            guard let baseCellModel = baseCellModel else { return }
//            
//            // 设置显示\隐藏
//            setupIsHidden(baseCellModel)
//            
//            // 设置数据
//            setupData(baseCellModel)
//        }
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: 10, y: 0, width: titleLabel.frame.width, height: frame.height)
        
        arrowImageView.frame = CGRect(x: frame.width - arrowImageViewWH - 10, y: 0, width: arrowImageViewWH, height: frame.height)
        
        iconImageView.frame = CGRect(x: frame.width - iconImageViewWH - arrowImageViewWH - 10, y: 0, width: iconImageViewWH, height: frame.height)
        
        subTitleLabel.sizeToFit()
        let subTitleLabelW = subTitleLabel.frame.width
        subTitleLabel.frame = CGRect(x: frame.width - subTitleLabelW - arrowImageViewWH - 10, y: 0, width: subTitleLabelW, height: frame.height)
        
    }
}

extension ProfileInforCell {
    
//    fileprivate func setupIsHidden(_ baseCellModel : BaseCellModel){
//        if baseCellModel is BaseCellSubModel {  // title subTitle
//            titleLabel.isHidden = false
//            iconImageView.isHidden = true
//            subTitleLabel.isHidden = false
//            arrowImageView.isHidden = true
//        }else if baseCellModel is BaseCellImageArrowModel{// title    image  arrowImage
//            titleLabel.isHidden = false
//            iconImageView.isHidden = false
//            subTitleLabel.isHidden = true
//            arrowImageView.isHidden = false
//        }else if baseCellModel is BaseCellArrowModel{ // title 和右边的箭头(可以跳转下个控制器)
//            titleLabel.isHidden = false
//            iconImageView.isHidden = true
//            subTitleLabel.isHidden = true
//            arrowImageView.isHidden = false
//        }else if baseCellModel is BaseCellSubArrowModel{ // title  subTitle  arrowImage
//            titleLabel.isHidden = false
//            iconImageView.isHidden = true
//            subTitleLabel.isHidden = false
//            arrowImageView.isHidden = false
//        }else{   // title
//            titleLabel.isHidden = false
//            iconImageView.isHidden = true
//            subTitleLabel.isHidden = true
//            arrowImageView.isHidden = true
//            
//        }
//        
//    }
}

extension ProfileInforCell {
    
//    fileprivate func setupData(_ baseCellModel : BaseCellModel){
//        titleLabel.text = baseCellModel.titleName
//        arrowImageView.image = UIImage(named: "")
//        if baseCellModel is BaseCellSubModel {  // title subTitle
//            let model = baseCellModel as! BaseCellSubModel
//            subTitleLabel.text = model.subTitle
//        }else if baseCellModel is BaseCellImageArrowModel{  // title 和右边的箭头(可以跳转下个控制器)
//            
//            let model = baseCellModel as! BaseCellImageArrowModel
//            guard let url = URL(string: model.imageName) else { return }
//            iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Img_default"), options: .allowInvalidSSLCertificates)
//            
//        }else if baseCellModel is BaseCellArrowModel{ // title    image  arrowImage
//            print("----")
//        }else if baseCellModel is BaseCellSubArrowModel{ // title  subTitle  arrowImage
//            let model = baseCellModel as! BaseCellSubArrowModel
//            subTitleLabel.text = model.subTitle
//        }else{   // title
//            print("----")
//        }
//        
//    }
}
