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

            guard let anchorGroup = anchorGroup else { return }
            
            titleLabel.text = anchorGroup.tag_name
            let string = anchorGroup.icon_url
            guard let url = URL(string: string) else { return }
            iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Img_default"), options: .allowInvalidSSLCertificates)
        }
    }
    
    /// 搜索结果显示的cate分类
    var searchRoomModel : SearchRoomModel?{
        
        didSet{
           guard let searchRoomModel = searchRoomModel else { return }
            
            titleLabel.text = searchRoomModel.noRed
            let string = searchRoomModel.icon_url
            guard let url = URL(string: string) else { return }
            iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Img_default"), options: .allowInvalidSSLCertificates)
        }
    }

}
