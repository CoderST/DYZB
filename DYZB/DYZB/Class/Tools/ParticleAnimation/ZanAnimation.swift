//
//  ZanAnimation.swift
//  点赞动画
//
//  Created by xiudou on 16/11/2.
//  Copyright © 2016年 dfpo. All rights reserved.
//

import UIKit

class ZanAnimation: NSObject {
    // MARK:- 单粒
    static let shareInstance = ZanAnimation()
    
    // MARK:- 常量
    var zanCount : Int32 = 0
    
    // MARK:- 懒加载
    
    // 加载的数组   此处主要是循环利用对象
    private lazy var keepArray : [UIImageView] = {
        
        let keepArray = [UIImageView]()
        return keepArray
        
    }()
    
    // 删除的数组
    private lazy var deletArray : [UIImageView] = {
        
        let deletArray = [UIImageView]()
        return deletArray
        
    }()
    
    /**
     粒子动画
     - parameter view:     显示在拿一个view上
     - parameter center_X: 动画的起始中心点X
     - parameter center_Y: 动画的起始中心点Y
     */
    func startAnimation(view : UIView,center_X : CGFloat,center_Y : CGFloat){
        
        if zanCount == INT_MAX{
            zanCount = 0
        }
        
        var tempImageView : UIImageView?
        let imageName = randomImageName()
        if deletArray.count > 0{
            tempImageView = deletArray.first
            tempImageView?.image = UIImage(named: imageName)
            deletArray.removeFirst()
        }else{
            guard let image = UIImage.init(named: imageName) else { return }
            tempImageView = UIImageView.init(image: image)
            // 初始位置(随便设置一个屏幕外的位置)
            tempImageView!.center = CGPointMake(-5000, -5000)
        }
        view.addSubview(tempImageView!)
        keepArray.append(tempImageView!)
        let group = groupAnimation(center_X, center_Y: center_Y)
        tempImageView!.layer.addAnimation(group, forKey: "ZanAnimation\(zanCount)")
        
    }
    
    
    
    private  func groupAnimation(center_X : CGFloat,center_Y : CGFloat) -> CAAnimationGroup{
        
        let group = CAAnimationGroup.init()
        group.duration = 2.0;
        group.repeatCount = 1;
        let animation = scaleAnimation()
        let keyAnima = positionAnimatin(center_X, center_Y: center_Y)
        let alphaAnimation = alphaAnimatin()
        group.animations = [animation, keyAnima, alphaAnimation]
        group.delegate = self;
        return group
    }
    
    
    private  func scaleAnimation() -> CABasicAnimation {
        // 设定为缩放
        let animation = CABasicAnimation.init(keyPath: "transform.scale")
        // 动画选项设定
        animation.duration = 0.5// 动画持续时间
        animation.removedOnCompletion = false
        
        // 缩放倍数
        animation.fromValue = 0.1 // 开始时的倍率
        animation.toValue = 1.0 // 结束时的倍率
        return animation
    }
    
    
    private  func positionAnimatin(center_X : CGFloat,center_Y : CGFloat) -> CAKeyframeAnimation {
        
        let keyAnima=CAKeyframeAnimation.init()
        keyAnima.keyPath="position"
        //1.1告诉系统要执行什么动画
        //创建一条路径
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, center_X , center_Y)
        // 控制点X波动值
        let controlX = Int((arc4random() % UInt32(60))) - 30
        // 控制点Y波动值
        let controlY = Int((arc4random() % UInt32(50)))
        // 端点X波动值
        let entX = Int((arc4random() % UInt32(100))) - Int(50)
        CGPathAddQuadCurveToPoint(path, nil, CGFloat(Int(center_X) - controlX), CGFloat(Int(center_Y) - controlY), CGFloat(Int(center_X) + entX), CGFloat(arc4random() % UInt32(50) + 150))
        keyAnima.path=path;
        //1.2设置动画执行完毕后，不删除动画
        keyAnima.removedOnCompletion = false
        //1.3设置保存动画的最新状态
        keyAnima.fillMode=kCAFillModeForwards
        //1.4设置动画执行的时间
        keyAnima.duration=2.0
        //1.5设置动画的节奏
        keyAnima.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        return keyAnima
    }
    
    
    private  func alphaAnimatin() -> CABasicAnimation {
        let alphaAnimation = CABasicAnimation.init(keyPath: "opacity")
        // 动画选项设定
        alphaAnimation.duration = 1.5 // 动画持续时间
        alphaAnimation.removedOnCompletion = false
        
        alphaAnimation.fromValue = 1.0
        alphaAnimation.toValue = 0.1
        alphaAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        alphaAnimation.beginTime = 0.5
        
        return alphaAnimation
    }
    private func randomImageName() -> String {
        
        let number = Int(arc4random() % (8 + 1));
        var randomImageName: String
        switch (number) {
        case 1:
            randomImageName = "good1_30x30"
            break;
        case 2:
            randomImageName = "good2_30x30"
            break;
        case 3:
            randomImageName = "good3_30x30"
            break;
        case 4:
            randomImageName = "good4_30x30"
            break;
        case 5:
            randomImageName = "good5_30x30"
            break;
        case 6:
            randomImageName = "good6_30x30"
            break;
        case 7:
            randomImageName = "good7_30x30"
            break;
        case 8:
            randomImageName = "good8_30x30"
            break;
        default:
            randomImageName = "good9_30x30"
            break;
        }
        return randomImageName
    }
}

// MARK:- CAAnimationGroup代理方法
extension ZanAnimation{
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        guard let tempImageView = keepArray.first else { return }
        tempImageView.layer.removeAllAnimations()
        deletArray.append(tempImageView)
        keepArray.removeFirst()
    }
    
}

