//
//  EmitterLayer_ST.swift
//  lizi
//
//  Created by xiudou on 16/11/1.
//  Copyright © 2016年 xiudo. All rights reserved.
//  // 粒子动画

import UIKit

class EmitterLayer_ST: CAEmitterLayer {
    init(centerx : CGFloat , centery : CGFloat, view : UIView) {
        super.init()
        // 发射器在xy平面的中心位置
        emitterPosition = CGPoint(x: centerx, y: centery)
        // 发射器的尺寸大小
        emitterSize = CGSize(width: 20, height: 20)
        // 渲染模式
        renderMode = kCAEmitterLayerUnordered
        var tempArray = [CAEmitterCell]()
        for i in 0..<10{
             // 发射单元
            let stepCell = CAEmitterCell()
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = Float(arc4random_uniform(4)) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            let imageName = "good\(i)_30x30"
            let image = UIImage(named: imageName)
            // 粒子显示的内容
            stepCell.contents = image?.CGImage
            // 粒子的运动速度
            stepCell.velocity = CGFloat(arc4random_uniform(100) + 100);
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = CGFloat(M_PI + M_PI_2)
            // 粒子发射角度的容差
            stepCell.emissionRange = CGFloat(M_PI_2 / 6);
            // 缩放比例
            stepCell.scale = 0.3;
            tempArray.append(stepCell)
        }
        
        emitterCells = tempArray
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
