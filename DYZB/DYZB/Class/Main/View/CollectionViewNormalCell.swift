//
//  CollectionViewNormalCell.swift
//  DYZB
//
//  Created by xiudou on 16/9/19.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class CollectionViewNormalCell: CollectionBaseCell {

    @IBOutlet weak var roomeLabel: UILabel!

    override var anchorModel : AnchorModel? {
        
        didSet{
            guard let anchor = anchorModel else { return }
            // 将model传递给父类,让父类(此处也可以说是公共类)实现相应的UI展示
            super.anchorModel = anchor
            roomeLabel.text = anchor.room_name
        }
    }

}
