//
//  FishboneRechargBottomView.swift
//  DYZB
//
//  Created by xiudou on 2017/7/5.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
