//
//  GameCenterCell.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import SVProgressHUD
fileprivate let iconImageViewWidth : CGFloat = 140
fileprivate let iconImageViewHeight : CGFloat = iconImageViewWidth * 0.5
fileprivate let downButtonWidth : CGFloat = 50
fileprivate let downButtonHeight : CGFloat = downButtonWidth * 0.5
fileprivate let titltFont : UIFont = UIFont.boldSystemFont(ofSize: 14)
fileprivate let subTitltFont : UIFont = UIFont.systemFont(ofSize: 12)
class GameCenterCell: UICollectionViewCell {
    
    fileprivate let iconImageView : UIImageView = {
        
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleToFill
        iconImageView.layer.cornerRadius = 6
        iconImageView.clipsToBounds = true
        return iconImageView
        
    }()
    
    fileprivate let titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = titltFont
        return titleLabel
        
    }()
    
    fileprivate let subTitleLabel : UILabel = {
        
        let subTitleLabel = UILabel()
        subTitleLabel.numberOfLines = 2
        subTitleLabel.font = subTitltFont
        return subTitleLabel
        
    }()
    
    fileprivate let downButton : DownButton = DownButton(frame: CGRect.zero, title: "下载", backGroundColor: UIColor.orange,font: UIFont.systemFont(ofSize: 12), cornerRadius: 5)
    
    
    fileprivate let bottomLine : UIView = {
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.gray
        return bottomLine
        
    }()
    
    var gameCenterModel : GameCenterModel?{
        
        didSet{
            guard let gameCenterModel = gameCenterModel else { return }
            guard let url = URL(string: gameCenterModel.icon) else { return }
            iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Img_default"), options: .allowInvalidSSLCertificates)
            titleLabel.text = gameCenterModel.title
            subTitleLabel.text = gameCenterModel.get_depict
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(downButton)
        contentView.addSubview(bottomLine)
        
        downButton.addTarget(self, action: #selector(downButtonAction), for: .touchUpInside)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(x: 10, y: (frame.height - iconImageViewHeight) * 0.5, width: iconImageViewWidth, height: iconImageViewHeight)
        if let titleLabelSize = gameCenterModel?.title.sizeWithFont(titltFont, size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))){
            
            titleLabel.frame = CGRect(x: iconImageView.frame.maxX + 10, y: iconImageView.frame.origin.y, width: titleLabelSize.width, height: titleLabelSize.height)
        }else{
            titleLabel.frame = CGRect(x: iconImageView.frame.maxX + 10, y: iconImageView.frame.origin.y, width: sScreenW, height: titleLabel.font.lineHeight)
        }
        
        if let subTitleLabelSize = gameCenterModel?.get_depict.sizeWithFont(subTitltFont, size: CGSize(width: 100, height: CGFloat(MAXFLOAT))){
            
            subTitleLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY + 5, width: subTitleLabelSize.width, height: subTitleLabelSize.height)
        }
        
        downButton.frame = CGRect(x: sScreenW - downButtonWidth - 10, y: titleLabel.frame.maxY + 2, width: downButtonWidth, height: downButtonHeight)
        
        bottomLine.frame = CGRect(x: 0, y: frame.height - 1, width: sScreenW, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameCenterCell {
    
    @objc fileprivate func downButtonAction() {
        
        guard let gameCenterModel = gameCenterModel else { return }
        guard let url = URL(string: gameCenterModel.down_ios_url) else { return }
        if UIApplication.shared.canOpenURL(url) == true{
            UIApplication.shared.openURL(url)
        }else{
            SVProgressHUD.showError(withStatus: "url失效")
        }
    }
}
