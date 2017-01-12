//
//  PresentModel.swift
//  PresentVC
//
//  Created by xiudou on 16/11/9.
//  Copyright © 2016年 xiudo. All rights reserved.

/**
用法:
1 创建弹出控制器
2 实现转场动画代理方法(此处只要代理设为PresentModel的实例就行)
3 设置样式 -> 默认是上下样式
4 弹出界面
*/

import UIKit

enum animation_Type{
    
    case upDown // 上下样式
    case scale  // 缩放模式
}

class PresentModel: NSObject {
    
       // MARK:- 对外
    var animationType : animation_Type = .upDown
    var presentedFrame : CGRect = CGRect.zero
    // MARK:- 私有
    /// 是否已经Presented出控制器
    fileprivate var isPersent : Bool =  false
    fileprivate let tempY : CGFloat = 2000
    fileprivate let transitionDuration : TimeInterval = 0.8
    

}

// MARK: - UIViewControllerTransitioningDelegate
extension PresentModel : UIViewControllerTransitioningDelegate{
    // 目的:改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentation = STPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedFrame = presentedFrame
        
        return presentation
    }
    
    /** 弹出调用 */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        isPersent = true
        
        return self
    }
    
    /** 消失调用 */
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        isPersent = false
        
        return self
    }
    
}
// MARK: - UIViewControllerAnimatedTransitioning
extension PresentModel : UIViewControllerAnimatedTransitioning{
    /** 转场时间 */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        
        return transitionDuration
    }
    
    /** 转场过程动画实现 */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            guard let toView =  transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
            transitionContext.containerView.addSubview(toView)
            
            
            if animationType == .upDown{
                toView.center.y = tempY
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    toView.center.y = UIScreen.main.bounds.size.height * 0.5
                    }) { (finished: Bool) in
                        transitionContext.completeTransition(true)
                }
                
            }else{
                toView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                    toView.transform = CGAffineTransform.identity
                    }, completion: { (_) -> Void in
                        transitionContext.completeTransition(true)
                })
                
            }
            
        }else{
            
            guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
            if animationType == .upDown{
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                    fromView.center.y = self.tempY
                    }, completion: { (_) -> Void in
                        transitionContext.completeTransition(true)
                })
                
            }else{
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                    fromView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
                    }, completion: { (_) -> Void in
                        transitionContext.completeTransition(true)
                })
            }
            
        }
    }
}

