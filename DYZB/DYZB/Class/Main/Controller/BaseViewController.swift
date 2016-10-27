//
//  BaseViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    
    var baseContentView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    
    private lazy var animationImageView : UIImageView = { [weak self] in
       
         let animationImageView = UIImageView(image: UIImage(named: "img_loading_1"))
        animationImageView.center = self!.view.center
        animationImageView.animationImages = [UIImage(named: "img_loading_1")!,UIImage(named: "img_loading_2")!]
        animationImageView.autoresizingMask = [.FlexibleTopMargin,.FlexibleBottomMargin]
        animationImageView.animationDuration = 0.5
        animationImageView.animationRepeatCount = LONG_MAX
        return animationImageView
        
    }()

}

extension BaseViewController {
    
    func setupUI(){
        
        baseContentView?.hidden = true
        
        view.addSubview(animationImageView)
        
        animationImageView.hidden = false
        
        animationImageView.startAnimating()
        
        view.backgroundColor = UIColor(r: 250, g: 250, b: 250)
    }
    
    func endAnimation(){
        
        animationImageView.stopAnimating()
        
        animationImageView.hidden = true
        
        baseContentView?.hidden = false
    }
}
