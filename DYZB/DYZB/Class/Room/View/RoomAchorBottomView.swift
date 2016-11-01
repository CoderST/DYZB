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
    case Danmu = 0
    case LiaoTian
    case LiWu
    case JiangBei
    case FenXiang
    case GuanBi
}
protocol RoomAchorBottomViewDelegate:NSObjectProtocol {
    //设置协议方法
    func bottomViewClick(imageType : imageViewType)
}
class RoomAchorBottomView: UIView {

    
//    typealias valueBlock = (Int)->()
//    var returnPrice: valueBlock?
    
    weak var delegate : RoomAchorBottomViewDelegate?
    
    private let imageNames = ["talk_public_40x40", "talk_private_40x40", "talk_sendgift_40x40", "talk_rank_40x40", "talk_share_40x40", "talk_close_40x40"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = true
        backgroundColor = UIColor.clearColor()
        let WH : CGFloat = 40
        var X : CGFloat = 0
        let Y : CGFloat = 0
        let margin = (sScreenW - WH * CGFloat(imageNames.count)) / CGFloat(imageNames.count + 1)
        for i in 0..<imageNames.count{
            let imageView = UIImageView()
            imageView.userInteractionEnabled = true
            imageView.tag = i
            X = margin + (margin + WH) * CGFloat(i);
            imageView.frame = CGRect(x: X, y: Y, width: WH, height: WH)
            imageView.image = UIImage(named: imageNames[i])
            let tap = UITapGestureRecognizer(target: self, action: "tapClick:")
            imageView.addGestureRecognizer(tap)
            addSubview(imageView)
            
        }
    }
    
    
    func tapClick(tapRec:UITapGestureRecognizer){

        let tag = tapRec.view!.tag
        
        delegate?.bottomViewClick(imageViewType(rawValue: tag)!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
