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
        /*
         // MARK:- 不用自己的POP有个bug(在简书解决问题:http://www.jianshu.com/p/9461f79b14b7)
         我的详情界面(ProfileInforViewController) 在下拉或者上拉的时候会调用我界面(ProfileViewController)viewWillAppear的方法
         所以改用第三方FDFullscreenPopGesture
         */
        
        
        addPopGesture()
        
        setupNavigation()

        
       
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0{
            
            setupBack(viewController)
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
}

// MARK:- 添加全局POP手势
extension MainNavigationController {
    
    @objc fileprivate func addPopGesture(){
        
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
}

/// 设置全局Navigation
extension MainNavigationController{
    func setupNavigation(){
        let bar = UINavigationBar.appearance()
        // 添加全局bar背景 要加下面这一句
        bar.isTranslucent = true
        let backgroundImage = UIImage(named: "Img_orange")
        bar.setBackgroundImage(backgroundImage, for: .default)
        
        var barAttrs : [String : Any] = [String : Any]()
        barAttrs[NSForegroundColorAttributeName] = UIColor.white
        barAttrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 18)
        bar.titleTextAttributes = barAttrs
        
        let item = UIBarButtonItem.appearance()
        
        var normalAttrs : [String : Any] = [String : Any]()
        normalAttrs[NSForegroundColorAttributeName] = UIColor.white
        normalAttrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 15)
        item.setTitleTextAttributes(normalAttrs, for: .normal)
        
        var disableAttrs : [String : Any] = [String : Any]()
        disableAttrs[NSForegroundColorAttributeName] = UIColor.gray
        item.setTitleTextAttributes(disableAttrs, for: .disabled)
    }
}

/// 设置全局返回
extension MainNavigationController{
    
    func setupBack(_ viewController: UIViewController){
        let backButton = UIButton(type: .custom)
        let image = UIImage(named: "navBackBtn")
        backButton.setImage(image, for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc fileprivate func backButtonAction(){
        popViewController(animated: true)
    }
}
