//
//  RoomAchorBottomView.swift
//  DYZB
//
//  Created by xiudou on 16/10/31.
//  Copyright © 2016年 xiudo. All rights reserved.
//  直播底部的view(分享,送礼物,删除等)

import UIKit
// 弹幕 聊天 礼物 奖杯 分享  关闭
enum imageViewType : Int {
    case danmu = 0
    case liaoTian
    case liWu
    case jiangBei
    case fenXiang
    case guanBi
}
protocol RoomAchorBottomViewDelegate:NSObjectProtocol {
    //设置协议方法
    func bottomViewClick(_ imageType : imageViewType)
}
class RoomAchorBottomView: UIView {

    
//    typealias valueBlock = (Int)->()
//    var returnPrice: valueBlock?
    
    weak var delegate : RoomAchorBottomViewDelegate?
    
    fileprivate let imageNames = ["talk_public_40x40", "talk_private_40x40", "talk_sendgift_40x40", "talk_rank_40x40", "talk_share_40x40", "talk_close_40x40"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
        let WH : CGFloat = 40
        var X : CGFloat = 0
        let Y : CGFloat = 0
        let margin = (sScreenW - WH * CGFloat(imageNames.count)) / CGFloat(imageNames.count + 1)
        for i in 0..<imageNames.count{
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
            imageView.tag = i
            X = margin + (margin + WH) * CGFloat(i);
            imageView.frame = CGRect(x: X, y: Y, width: WH, height: WH)
            imageView.image = UIImage(named: imageNames[i])
            let tap = UITapGestureRecognizer(target: self, action: #selector(RoomAchorBottomView.tapClick(_:)))
            imageView.addGestureRecognizer(tap)
            addSubview(imageView)
            
        }
    }
    
    
    func tapClick(_ tapRec:UITapGestureRecognizer){

        let tag = tapRec.view!.tag
        
        delegate?.bottomViewClick(imageViewType(rawValue: tag)!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
