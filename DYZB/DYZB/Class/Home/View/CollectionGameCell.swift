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
            guard let string = anchorGroup?.icon_url else { return }
            guard let url = URL(string: string) else { return }
            iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Img_default"))
            
        }
    }

}
