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
        
//        navigationBar.barTintColor = UIColor.orange
        
        // 手势 -> 手势对应的view -> target , arction
        // 1 获取系统手势
        guard let popGesture = interactivePopGestureRecognizer else { return }
        // 2 获取手势对应view
        guard let popGestureView = popGesture.view else { return }
        // 3 获取系统手势中targets的所有事件
        guard let targets = popGesture.value(forKey: "_targets") as? [NSObject] else { return }
        // 4 取出手势对象
        guard let targetObec = targets.first else { return }
        // 5 获得手势事件
        let target = targetObec.value(forKey: "target")
        // 6 创建action
        let action = Selector(("handleNavigationTransition:"))
        // 7 创建自己的手势
        let panGest = UIPanGestureRecognizer()
        // 8 添加手势
        popGestureView.addGestureRecognizer(panGest)
        // 9 给手势添加事件
        panGest.addTarget(target!, action: action)
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        viewController.hidesBottomBarWhenPushed = true
        
        super.pushViewController(viewController, animated: true)
    }

}
