//
//  PresentationController.swift
//  DYZB
//
//  Created by xiudou on 16/11/9.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class STPresentationController: UIPresentationController {

    var presentedFrame : CGRect = CGRectZero
    
    // MARK:- 懒加载
    private lazy var coverView : UIView = UIView()
    
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView()?.frame = presentedFrame
        
        setupConverView()
    }
    
}

extension STPresentationController {
    
    private func setupConverView(){
        
        containerView?.insertSubview(coverView, atIndex: 0)
        coverView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        coverView.frame = containerView!.bounds
        
        let tapGes = UITapGestureRecognizer(target: self, action: "coverViewClick")
        coverView.addGestureRecognizer(tapGes)

    }
}

extension STPresentationController {
    
    @objc private func coverViewClick(){
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
