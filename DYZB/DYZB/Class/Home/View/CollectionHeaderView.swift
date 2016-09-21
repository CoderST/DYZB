//
//  CollectionHeaderView.swift
//  DYZB
//
//  Created by xiudou on 16/9/19.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    var anchorGroup : AnchorGroup? {
        
        didSet{
            
            guard let group = anchorGroup else { return }
            iconImageView.image = UIImage(named:group.icon_name)
            titleLabel.text = group.tag_name
            
        }
    }

}
