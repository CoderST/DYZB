//
//  WatchHistoryCell.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
let WatchHistoryTitleLabelFont : UIFont = UIFont.systemFont(ofSize: 12)
let WatchHistorySubTitleLabelFont : UIFont = UIFont.systemFont(ofSize: 10)
let WatchHistoryTimeLabelFont : UIFont = WatchHistorySubTitleLabelFont
fileprivate let subTitleLabelFontSize : CGFloat = 10
fileprivate let timeLabelFontSize : CGFloat = subTitleLabelFontSize
class WatchHistoryCell: UICollectionViewCell {
    
    fileprivate let iconImageView : UIImageView = {
        
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleToFill
        iconImageView.layer.cornerRadius = 6
        iconImageView.clipsToBounds = true
        return iconImageView
        
    }()
    
    fileprivate let titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = WatchHistoryTitleLabelFont
        return titleLabel
        
    }()
    
    fileprivate let subTitleLabel : UILabel = {
        
        let subTitleLabel = UILabel()
        subTitleLabel.numberOfLines = 2
        subTitleLabel.font = WatchHistorySubTitleLabelFont
        return subTitleLabel
        
    }()
    
    fileprivate let timeLabel : UILabel = {
        
        let timeLabel = UILabel()
        timeLabel.font = WatchHistoryTimeLabelFont
        return timeLabel
        
    }()

    fileprivate let lineView : UIView = {
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(lineView)
    }
    
    var watchHistoryModelFrame : WatchHistoryModelFrame?{
        
        didSet{
            guard let watchHistoryModelFrame = watchHistoryModelFrame else { return }
            
            setupData(watchHistoryModelFrame)
            setupFrame(watchHistoryModelFrame)
            
        }
    }
    
    fileprivate func setupData(_ watchHistoryModelFrame : WatchHistoryModelFrame){
        let watchHistoryModel = watchHistoryModelFrame.watchHistoryModel
        guard let url = URL(string: watchHistoryModel.room_src) else { return }
        iconImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Img_default"), options: .allowInvalidSSLCertificates)
        titleLabel.text = watchHistoryModel.room_name
        subTitleLabel.text = watchHistoryModel.nickname
        timeLabel.text = watchHistoryModelFrame.handleTime
        subTitleLabel.text = watchHistoryModel.nickname
    }
    
    fileprivate func setupFrame(_ watchHistoryModelFrame : WatchHistoryModelFrame){
        iconImageView.frame = watchHistoryModelFrame.room_srcFrame
        titleLabel.frame = watchHistoryModelFrame.room_nameFrame
        subTitleLabel.frame = watchHistoryModelFrame.nicknameFrame
        timeLabel.frame = watchHistoryModelFrame.show_timeFrame
        lineView.frame = watchHistoryModelFrame.lineViewFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
