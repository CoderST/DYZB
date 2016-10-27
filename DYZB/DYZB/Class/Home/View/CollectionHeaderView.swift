//
//  CollectionHeaderView.swift
//  DYZB
//
//  Created by xiudou on 16/9/19.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
//FIXME: 此处继承UICollectionReusableView,xib布局会出现错误,继承UICollectionViewCell没有问题
class CollectionHeaderView: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var moreButton: UIButton!
    var anchorGroup : AnchorGroup? {
        
        didSet{
            
            guard let group = anchorGroup else { return }
            iconImageView.image = UIImage(named:group.icon_name)
            titleLabel.text = group.tag_name
            
        }
    }

}

// MARK:- 从Xib中快速创建的类方法
extension CollectionHeaderView {
    class func collectionHeaderView() -> CollectionHeaderView {
        return NSBundle.mainBundle().loadNibNamed("CollectionHeaderView", owner: nil, options: nil).first as! CollectionHeaderView
    }
}
