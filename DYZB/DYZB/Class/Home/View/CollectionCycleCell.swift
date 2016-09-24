//
//  CollectionCycleCell.swift
//  DYZB
//
//  Created by xiudou on 16/9/23.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import SDWebImage
class CollectionCycleCell: UICollectionViewCell {

    @IBOutlet weak var cycleBackgroundImage: UIImageView!
    @IBOutlet weak var cycleNameLabel: UILabel!

    
    var cycleModel : CycleModel?{
        
        didSet{
            guard let cycleM = cycleModel else {return}
            cycleNameLabel.text = cycleM.title
            cycleBackgroundImage.sd_setImageWithURL(NSURL(string: cycleM.pic_url), placeholderImage: UIImage(named: "Img_default"))
        }
    }

}
