//
//  MainNavigationController.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 手势 -> 手势对应的view -> target , arction
        // 1 获取系统手势
        guard let popGesture = interactivePopGestureRecognizer else { return }
        // 2 获取手势对应view
        guard let popGestureView = popGesture.view else { return }
        
//        var count : UInt32 = 0
//        let ivars = class_copyIvarList(UIGestureRecognizer.self, &count)
//        for i in 0..<count{
//            let ivar = ivars[Int(i)]
//            let name = ivar_getName(ivar)
////            print(String(CString: name, encoding: NSUTF8StringEncoding)!)
//            /**
//            _targets -> 需要
//            _delayedTouches
//            _delayedPresses
//            _view
//            _updateEvent
//            _updateButtonEvent
//            _lastTouchTimestamp
//            _delegate
//            _friends
//            _state
//            _allowedTouchTypes
//            _initialTouchType
//            _internalActiveTouches
//            _forceClassifier
//            _requiredPreviewForceState
//            _forceFailureRequirement
//            _touchForceObservable
//            _touchForceObservableAndClassifierObservation
//            _forceTargets
//            _forcePressCount
//            _beganObservable
//            _gestureFlags
//            _failureRequirements
//            _failureDependents
//            _dynamicFailureRequirements
//            _dynamicFailureDependents
//            _relationshipFailureRequirement
//            _allowedPressTypes
//
//            */
//            
//            
//        }
        // 3 获取系统手势中targets的所有事件
        guard let targets = popGesture.valueForKey("_targets") as? [NSObject] else { return }
//        guard let actionn = popGesture.valueForKey("handleNavigationTransition:") as? Selector else { return }
        /**
         "(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7f838ad54520>)"
        */
        
        // 4 取出手势对象
        guard let targetObec = targets.first else { return }
        // 5 获得手势事件
        let target = targetObec.valueForKey("target")
        // 6 创建action
        let action = Selector("handleNavigationTransition:")
        // 7 创建自己的手势
        let panGest = UIPanGestureRecognizer()
        // 8 添加手势
        popGestureView.addGestureRecognizer(panGest)
        // 9 给手势添加事件
        panGest.addTarget(target!, action: action)
        
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        viewController.hidesBottomBarWhenPushed = true
        
        super.pushViewController(viewController, animated: true)
    }

}
