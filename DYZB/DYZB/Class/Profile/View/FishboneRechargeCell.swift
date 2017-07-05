//
//  FishboneRechargeCell.swift
//  DYZB
//
//  Created by xiudou on 2017/7/4.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let cornerRadius : CGFloat = 2
class FishboneRechargeCell: UICollectionViewCell {
    
    fileprivate lazy var selectedFishboneRechargeModel : FishboneRechargeModel = FishboneRechargeModel()
    
    fileprivate lazy var titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
        
    }()
    
    lazy var boderView : UIView = {
        
        let boderView = UIView()
        boderView.layer.cornerRadius = 5
        boderView.layer.masksToBounds = true
        boderView.layer.borderWidth = cornerRadius
        boderView.backgroundColor = UIColor.clear
        boderView.layer.borderColor = UIColor.orange.cgColor
        return boderView
        
    }()
    
    var fishboneRechargeModel : FishboneRechargeModel?{
        
        didSet{
            
            guard let fishboneRechargeModel = fishboneRechargeModel else { return }
            let title = "\(fishboneRechargeModel.gold)鱼刺\n¥\(fishboneRechargeModel.rmb)\n赠送\(fishboneRechargeModel.exp)经验"
            titleLabel.text = title
         
            if fishboneRechargeModel.default_select == "1" {
                boderView.isHidden = false
            }else{
                boderView.isHidden = true
            }
            
        }
    }
    
    func didSelectedModelAction(_ fishboneRechargeModel : FishboneRechargeModel){
        boderView.isHidden = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(boderView)
//        selectedBackgroundView = boderView
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
        boderView.frame = bounds
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
