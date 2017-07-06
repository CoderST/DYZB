//
//  FishboneRechargBottomView.swift
//  DYZB
//
//  Created by xiudou on 2017/7/5.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let margin : CGFloat = 20
fileprivate let titleLabelHeight : CGFloat = 40
fileprivate let extraAwardLabelHeight : CGFloat = 30
class FishboneRechargBottomView: UIView {
// extra
    fileprivate lazy var titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .orange
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    /// 额外奖励
    fileprivate lazy var extraAwardLabel : UILabel = {
        
        let extraAwardLabel = UILabel()
        extraAwardLabel.font = UIFont.systemFont(ofSize: 12)
        return extraAwardLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(extraAwardLabel)
        
    }
    
    var fishboneRechargeModel : FishboneRechargeModel?{
        
        didSet{
            guard let fishboneRechargeModel = fishboneRechargeModel else { return }
            let titleString = "立即支付\(fishboneRechargeModel.rmb)元"
            titleLabel.text = titleString
            
            let extraAwardString = "额外奖励\(fishboneRechargeModel.recharge_reward_msg)"
            let extraAwardAttString = extraAwardString.dy_changeColorWithTextColor(textColor: UIColor.orange, changeText: fishboneRechargeModel.recharge_reward_msg)
            extraAwardLabel.attributedText = extraAwardAttString
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: margin, y: frame.height - titleLabelHeight, width: frame.width - 2 * margin, height: titleLabelHeight)
        
        extraAwardLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y - extraAwardLabelHeight, width: titleLabel.frame.width, height: extraAwardLabelHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
