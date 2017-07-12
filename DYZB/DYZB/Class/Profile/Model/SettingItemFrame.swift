//
//  SettingItemFrame.swift
//  DYZB
//
//  Created by xiudou on 2017/7/11.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
let nicknameFont : UIFont = UIFont.systemFont(ofSize: 12)
let subTitleFont = nicknameFont

fileprivate let ItemFrameMargin : CGFloat = 10

fileprivate let arrowWH : CGFloat = 20
fileprivate let iconWH : CGFloat = 20
fileprivate let avatarWH : CGFloat = 40

class SettingItemFrame: NSObject {

    /// 左边的icon
    var iconImageViewFrame : CGRect = CGRect.zero   // 可有可无
    /// 左边的标题
    var titleFrame : CGRect = CGRect.zero
    /// 右边的头像
    var headImageViewFrame : CGRect = CGRect.zero  // 可有可无
    /// 右边的标题
    var subTitleFrame : CGRect = CGRect.zero  // 可有可无
    /// 右侧的箭头
    var arrowFrame : CGRect = CGRect.zero    // 可有可无
    /// 底部线
    var bottomLineFrame : CGRect = CGRect.zero
    
    var settingItem : SettingItem
    
    init(_ settingItem : SettingItem) {
        self.settingItem = settingItem
        super.init()
        // 判断是哪一种类型的model  ArrowImageItem ArrowItem必有箭头 SettingItem没有箭头
        if settingItem is ArrowImageItem  {  /// 带右边的头像的item
            let arrowImageItem = settingItem as! ArrowImageItem
            
            
            arrowFrame = CGRect(x: sScreenW - arrowWH - ItemFrameMargin, y: (headImageCellHeight - arrowWH) * 0.5, width: arrowWH, height: arrowWH)
            
            /// 右侧头像
            headImageViewFrame = CGRect(x: arrowFrame.origin.x - ItemFrameMargin - avatarWH, y: (headImageCellHeight - avatarWH) * 0.5, width: avatarWH, height: avatarWH)
            
            ///  左边的icon不存在
            if arrowImageItem.icon == nil || arrowImageItem.icon == ""{
                iconImageViewFrame = CGRect(x: ItemFrameMargin, y: 0, width: 0, height: 0)
                /// 左边的标题
                let titleSize = arrowImageItem.title.sizeWithFont(nicknameFont, size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
                titleFrame = CGRect(x: iconImageViewFrame.maxX, y: (headImageCellHeight - titleSize.height) * 0.5, width: titleSize.width, height: titleSize.height)
                
                
            }else{
                
                iconImageViewFrame = CGRect(x: ItemFrameMargin, y: (normalCellHeight - iconWH) * 0.5, width: iconWH, height: iconWH)
                /// 左边的标题
                let titleSize = arrowImageItem.title.sizeWithFont(nicknameFont, size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
                titleFrame = CGRect(x: iconImageViewFrame.maxX + ItemFrameMargin, y: (headImageCellHeight - titleSize.height) * 0.5, width: titleSize.width, height: titleSize.height)
            }
            
            
        }else if settingItem is ArrowItem{   // 普通类型
            
            let arrowItem = settingItem as! ArrowItem
            
            /// 箭头
                arrowFrame = CGRect(x: sScreenW - arrowWH - ItemFrameMargin, y: (normalCellHeight - arrowWH) * 0.5, width: arrowWH, height: arrowWH)
            /// 右边的标题
            let subTitleSize = arrowItem.subTitle.sizeWithFont(subTitleFont, size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
            subTitleFrame = CGRect(x: arrowFrame.origin.x - ItemFrameMargin - subTitleSize.width, y: (normalCellHeight - subTitleSize.height) * 0.5, width: subTitleSize.width, height: subTitleSize.height)
            
            ///  左边的icon
            if arrowItem.icon == nil || arrowItem.icon == "" {   //  左边的icon不存在
                iconImageViewFrame = CGRect(x: ItemFrameMargin, y: 0, width: 0, height: 0)
                /// 左边的标题
                let titleSize = arrowItem.title.sizeWithFont(nicknameFont, size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
                titleFrame = CGRect(x: iconImageViewFrame.maxX, y: (normalCellHeight - titleSize.height) * 0.5, width: titleSize.width, height: titleSize.height)
                
                
            }else{
                iconImageViewFrame = CGRect(x: ItemFrameMargin, y: (normalCellHeight - iconWH) * 0.5, width: iconWH, height: iconWH)
                /// 左边的标题
                let titleSize = arrowItem.title.sizeWithFont(nicknameFont, size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
                titleFrame = CGRect(x: iconImageViewFrame.maxX + ItemFrameMargin, y: (normalCellHeight - titleSize.height) * 0.5, width: titleSize.width, height: titleSize.height)
                
            }
            
            
        }else{
            /// 右边的标题
            let settingItem = settingItem 
            let subTitleSize = settingItem.subTitle.sizeWithFont(subTitleFont, size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
            subTitleFrame = CGRect(x: sScreenW - ItemFrameMargin - subTitleSize.width, y: (normalCellHeight - subTitleSize.height) * 0.5, width: subTitleSize.width, height: subTitleSize.height)
            
            ///  左边的icon
            if settingItem.icon == nil || settingItem.icon == "" {   //  左边的icon不存在
                iconImageViewFrame = CGRect(x: ItemFrameMargin, y: 0, width: 0, height: 0)
                /// 左边的标题
                let titleSize = settingItem.title.sizeWithFont(nicknameFont, size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
                titleFrame = CGRect(x: iconImageViewFrame.maxX, y: (normalCellHeight - titleSize.height) * 0.5, width: titleSize.width, height: titleSize.height)
                
                
            }else{
                iconImageViewFrame = CGRect(x: ItemFrameMargin, y: (normalCellHeight - iconWH) * 0.5, width: iconWH, height: iconWH)
                /// 左边的标题
                let titleSize = settingItem.title.sizeWithFont(nicknameFont, size: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)))
                titleFrame = CGRect(x: iconImageViewFrame.maxX + ItemFrameMargin, y: (normalCellHeight - titleSize.height) * 0.5, width: titleSize.width, height: titleSize.height)
                
            }
        }
        var X : CGFloat = 0
        var Y : CGFloat = normalCellHeight - 0.5
        if settingItem.title == "所在地" || settingItem.title == "QQ" || settingItem.title == "鱼翅" {
            X = 0
        }else{
            X = ItemFrameMargin
        }
        if settingItem is ArrowImageItem {
            Y = headImageCellHeight  - 0.5
        }
        bottomLineFrame = CGRect(x: X, y: Y, width: sScreenW - X, height: 0.5)
    }
}
