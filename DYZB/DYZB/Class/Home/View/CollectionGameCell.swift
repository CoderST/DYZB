//
//  CollectionGameCell.swift
//  DYZB
//
//  Created by xiudou on 16/9/24.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class CollectionGameCell: UICollectionViewCell {

   // MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var anchorGroup : BaseGameModel?{
        
        didSet{
            titleLabel.text = anchorGroup?.tag_name ?? ""
            let iconURL = NSURL(string: anchorGroup?.icon_url ?? "")!
            iconImageView.sd_setImageWithURL(iconURL, placeholderImage: UIImage(named: "home_more_btn"))
        }
    }

}
