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
    

    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var onLineNumber: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var anchorModel : AnchorModel?{
        
        didSet{
            guard let anchor = anchorModel else { return }
//            nickNameLabel.text = anchor.nickname
            guard let url = URL(string: anchor.vertical_src) else { return }
            iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Img_default"))
            
            // 处理在线人数
            var onlineString : String = ""
            if anchor.online > 10000{
                onlineString = "\(anchor.online / 10000)万人在线"
            }else{
                onlineString = "\(anchor.online)在线"
            }
            nickLabel.text = anchor.nickname
            onLineNumber.setTitle(onlineString, for: UIControlState())
        }
    }
    
}
