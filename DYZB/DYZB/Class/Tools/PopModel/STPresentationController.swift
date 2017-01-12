//
//  PresentationController.swift
//  DYZB
//
//  Created by xiudou on 16/11/9.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class STPresentationController: UIPresentationController {

    var presentedFrame : CGRect = CGRect.zero
    
    // MARK:- 懒加载
    fileprivate lazy var coverView : UIView = UIView()
    
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView?.frame = presentedFrame
        
        setupConverView()
    }
    
}

extension STPresentationController {
    
    fileprivate func setupConverView(){
        
        containerView?.insertSubview(coverView, at: 0)
        coverView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        coverView.frame = containerView!.bounds
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(STPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)

    }
}

extension STPresentationController {
    
    @objc fileprivate func coverViewClick(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
