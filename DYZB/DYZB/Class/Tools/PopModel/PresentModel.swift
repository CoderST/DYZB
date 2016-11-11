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
    
    case UpDown // 上下样式
    case Scale  // 缩放模式
}

class PresentModel: NSObject {
    
       // MARK:- 对外
    var animationType : animation_Type = .UpDown
    var presentedFrame : CGRect = CGRectZero
    // MARK:- 私有
    /// 是否已经Presented出控制器
    private var isPersent : Bool =  false
    private let tempY : CGFloat = 2000
    private let transitionDuration : NSTimeInterval = 0.8
    

}

// MARK: - UIViewControllerTransitioningDelegate
extension PresentModel : UIViewControllerTransitioningDelegate{
    // 目的:改变弹出View的尺寸
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let presentation = STPresentationController(presentedViewController: presented, presentingViewController: presenting)
        presentation.presentedFrame = presentedFrame
        
        return presentation
    }
    
    /** 弹出调用 */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        isPersent = true
        
        return self
    }
    
    /** 消失调用 */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        isPersent = false
        
        return self
    }
    
}
// MARK: - UIViewControllerAnimatedTransitioning
extension PresentModel : UIViewControllerAnimatedTransitioning{
    /** 转场时间 */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        
        return transitionDuration
    }
    
    /** 转场过程动画实现 */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        if isPersent{
            guard let toView =  transitionContext.viewForKey(UITransitionContextToViewKey) else { return }
            transitionContext.containerView()?.addSubview(toView)
            
            
            if animationType == .UpDown{
                toView.center.y = tempY
                UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    toView.center.y = UIScreen.mainScreen().bounds.size.height * 0.5
                    }) { (finished: Bool) in
                        transitionContext.completeTransition(true)
                }
                
            }else{
                toView.transform = CGAffineTransformMakeScale(0.00001, 0.00001)
                UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                    toView.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        transitionContext.completeTransition(true)
                })
                
            }
            
        }else{
            
            guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else { return }
            if animationType == .UpDown{
                
                UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                    fromView.center.y = self.tempY
                    }, completion: { (_) -> Void in
                        transitionContext.completeTransition(true)
                })
                
            }else{
                
                UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                    fromView.transform = CGAffineTransformMakeScale(0.00001, 0.00001)
                    }, completion: { (_) -> Void in
                        transitionContext.completeTransition(true)
                })
            }
            
        }
    }
}

