//
//  AnimationModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
protocol AnimationModelDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
}
enum Direction {
    case plus   // 顺时针
    case minus  // 逆时针
}
class AnimationModel: NSObject {

    var delegate : AnimationModelDelegate?

    /// 中间按钮->旋转
    func rorateAnimation(holdView: UIView, duration : TimeInterval, fromValue : Double,toValue : Double){
        
        let momAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        momAnimation.fromValue = NSNumber(value: fromValue) //左幅度
        momAnimation.toValue = NSNumber(value: toValue) //右幅度
        momAnimation.duration = duration
        momAnimation.repeatCount = 1 //无限重复
        momAnimation.fillMode = kCAFillModeForwards
        momAnimation.isRemovedOnCompletion = false
        holdView.layer.add(momAnimation, forKey: "centerLayer")
    }
    
    /*
     direction : 旋转方向
     view : 要执行动画的view
     rect : view的绝对尺寸
     startPoint : 开始点
     endPoint : 结束点
     controlPoint : 控制点
     finishBlock : 完成回调
     */
    func animationandView(direction : Direction, view : UIView, rect : CGRect, duration : TimeInterval, startPoint : CGPoint, endPoint : CGPoint, controlPoint :  CGPoint, finishBlock : ()->()){
        let layer = view.layer
        // 注意 position是中心点位置
        layer.position = startPoint
        
        let path = UIBezierPath()
        path.move(to: layer.position)
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        // 缩放
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        var scaleFromValue = 0
        var scaleToValue = 0
        if direction == .plus {
            scaleFromValue = 0
            scaleToValue = 1
        }else{
            scaleFromValue = 1
            scaleToValue = 0
        }
        scaleAnimation.fromValue = scaleFromValue
        scaleAnimation.toValue = scaleToValue
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        var rotateFromValue : Double = 0
        var rotateToValue : Double  = 0
        // 设定旋转角度
        if direction == .plus {
            rotateFromValue = -M_PI / 2
            rotateToValue = 0
        }else{
            rotateFromValue = 0
            rotateToValue = -M_PI / 2
        }
        
        rotateAnimation.fromValue = NSNumber(value: rotateFromValue)
        rotateAnimation.toValue = rotateToValue
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.path = path.cgPath
        
        let groups = CAAnimationGroup()
        groups.animations = [scaleAnimation,pathAnimation,rotateAnimation]
        groups.duration = duration
        // 完成之后防止闪回初始状态
        groups.isRemovedOnCompletion = false
        groups.fillMode = kCAFillModeForwards
        groups.delegate = self
        layer.add(groups, forKey: "group")
        finishBlock()
    }
}


// MARK:- 代理
extension AnimationModel : CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        
        delegate?.animationDidStop(anim, finished: flag)
    }
}
