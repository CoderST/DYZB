//
//  UIViewController+Extension.swift
//  DYZB
//
//  Created by xiudou on 16/11/1.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import SnapKit
//static var *gifKey = &gifKey
private var GifImageView_Key = 0
extension UIViewController{
    
    
    // 给UIViewController添加UIImageView属性
    private struct AssociatedKeys {
        static var DescriptiveName = "nsh_DescriptiveName"
    }
    var gifImageView: UIImageView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? UIImageView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self,&AssociatedKeys.DescriptiveName,newValue as UIImageView?,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                
            }
        }
    }

    /**
     给系统UIViewController添加getGifImageView对象
     */
//    func getGifImageView()->AnyObject?{
//        
//        return objc_getAssociatedObject(self, &GifImageView_Key)
//    }
//    
//    func setGifImageView(){
//        objc_setAssociatedObject(self, &GifImageView_Key, getGifImageView(), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//    }
    
    /**
     显示GIF加载动画
     */
    func showGifLoading(var images : [UIImage]?,var inView:UIView?){
 
        if images == nil{
            images = [UIImage(named: "hold1_60x72")!,UIImage(named: "hold2_60x72")!,UIImage(named: "hold3_60x72")!]
        }
        
        let gifImage = UIImageView()
        if inView == nil{
            inView = view
        }
        inView?.addSubview(gifImage)
        gifImageView = gifImage
        gifImage.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(0)
            make.width.equalTo(60)
            make.height.equalTo(70)
        }
        
        gifImage.playGifAnimation(images)
    }
    
    /**
     隐藏动画
     */
    func hideGifLoading(){
        gifImageView!.stopAnimating()
        gifImageView = nil
    }
}
