//
//  CollectionBaseCell.swift
//  DYZB
//
//  Created by xiudou on 16/9/20.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import SDWebImage
class CollectionBaseCell: UICollectionViewCell {
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var anchorModel : AnchorModel?{
        
        didSet{
            guard let anchor = anchorModel else { return }
//            nickNameLabel.text = anchor.nickname
            guard let url = NSURL(string: anchor.vertical_src) else { return }
            iconImageView.sd_setImageWithURL(url)
        }
    }
    
}
