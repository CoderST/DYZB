//
//  CollectionViewPrettyCell.swift
//  DYZB
//
//  Created by xiudou on 16/9/19.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class CollectionViewPrettyCell: CollectionBaseCell {

    @IBOutlet weak var roomLabel: UILabel!

    @IBOutlet weak var cityButton: UIButton!

    override var anchorModel : AnchorModel?{
        
        didSet{
             guard let anchor = anchorModel else { return }
            // 将model传递给父类
            super.anchorModel = anchor
            cityButton.setTitle(anchor.anchor_city, for: UIControlState())
        }
    }
}
