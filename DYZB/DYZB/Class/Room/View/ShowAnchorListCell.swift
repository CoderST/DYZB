//
//  ShowAnchorListCell.swift
//  DYZB
//
//  Created by xiudou on 16/11/5.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import SDWebImage
class ShowAnchorListCell: UICollectionViewCell {

    // MARK:- 常量
    fileprivate let iconRadius : CGFloat = 20
    // MARK:- 变量
    
    // MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var zhiBoImageView: UIImageView!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var onLineNumberLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    // MARK:- 懒加载
    
    var anchorModel : RoomYKModel?{
        
        didSet{
            guard let model = anchorModel else { return }
            iconImageView.layer.cornerRadius = iconRadius
            iconImageView.clipsToBounds = true
             iconImageView.sd_setImage(with: URL(string: model.smallpic ?? ""), placeholderImage: UIImage(named: "placeholder_head"))
             userNameLabel.text = model.myname ?? "秀兜用户"
//             zhiBoImageView
            
            let leveImageName = "girl_star" + "\(model.starlevel)" + "_40x19"
             levelImageView.image = UIImage(named: leveImageName)
             onLineNumberLabel.text = "\(model.allnum)"
             locationLabel.text = model.gps

            
            backGroundImageView.sd_setImage(with: URL(string: model.bigpic ?? ""), placeholderImage: UIImage(named: "profile_user_375x375"))
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

}
