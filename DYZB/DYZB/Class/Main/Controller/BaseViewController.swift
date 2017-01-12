//
//  BaseViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//  用于加载动画的父类控制器

import UIKit

class BaseViewController: UIViewController {

    // MARK:- 变量
    var baseContentView : UIView?
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    
    // MARK:- 懒加载
    fileprivate lazy var animationImageView : UIImageView = { [weak self] in
       
         let animationImageView = UIImageView(image: UIImage(named: "img_loading_1"))
        animationImageView.center = self!.view.center
        animationImageView.animationImages = [UIImage(named: "img_loading_1")!,UIImage(named: "img_loading_2")!]
        animationImageView.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin]
        animationImageView.animationDuration = 0.5
        animationImageView.animationRepeatCount = LONG_MAX
        return animationImageView
        
    }()

}

extension BaseViewController {
    
    func setupUI(){
        // 1 停止子类view的显示
        baseContentView?.isHidden = true
        // 2 添加加载动画控件
        view.addSubview(animationImageView)
        // 3 显示加载动画控件
        animationImageView.isHidden = false
        // 4 开始加载动画
        animationImageView.startAnimating()
        // 5 设置背景颜色
        view.backgroundColor = UIColor(r: 250, g: 250, b: 250)
    }
    
    /**
     结束,隐藏动画
     */
    func endAnimation(){
        
        animationImageView.stopAnimating()
        
        animationImageView.isHidden = true
        
        baseContentView?.isHidden = false
    }
}
