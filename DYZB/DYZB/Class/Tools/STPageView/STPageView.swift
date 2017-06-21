//
//  STPageView.swift
//  STPageView
//
//  Created by xiudou on 2016/12/5.
//  Copyright © 2016年 CoderST. All rights reserved.
//  主要的View

import UIKit

class STPageView: UIView {

    // MARK:- 定义属性
    fileprivate var titles : [String]
    fileprivate var childsVC : [UIViewController]
    fileprivate var parentVC : UIViewController
    fileprivate var style : STPageViewStyle
    fileprivate var titleView : STTitlesView!
    fileprivate var parentView : Any?
    
    // MARK:- 自定义构造函数
    // frame : 给定的尺寸
    // titles : 标题的内容数组
    // childsVC : 对应标题控制器数组
    // parentVC : 父类控制器
    // style : 指定样式
    // parentView : titleView被添加上的父类
    init(frame: CGRect, titles : [String], childsVC : [UIViewController], parentVC : UIViewController, style : STPageViewStyle, parentView : Any?) {
        // 初始化前一定要给属性赋值,不然会报super dont init 错误
        self.titles = titles
        self.parentVC = parentVC
        self.childsVC = childsVC
        self.style = style
        self.parentView = parentView
        super.init(frame: frame)
        
        stupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension STPageView {
    
    fileprivate func stupUI(){
        // 1 创建TitlesView
        stupTitleView()
        
        // 2 创建内容View
        setupContentView()
        
    }
    
    fileprivate func stupTitleView(){
        let titleviewF = CGRect(x: 0, y: 0, width: self.frame.width, height: style.titleViewHeight)
        titleView = STTitlesView(frame: titleviewF, titles: self.titles, style: self.style)
        titleView.backgroundColor = style.titleViewBackgroundColor
        if parentView == nil{
            
            addSubview(titleView)
        }else{
            guard let parentView = parentView as? UIView else { return }
            parentView.addSubview(titleView)
        }

    }
    
    fileprivate func setupContentView(){
        var contentViewY : CGFloat = 0
        var contentViewH : CGFloat = 0
        if parentView == nil{
            contentViewY = style.titleViewHeight
            contentViewH = frame.height - style.titleViewHeight
        }else {
            contentViewY = 0
            contentViewH = frame.height
        }
        
        let contentViewF = CGRect(x: 0, y: contentViewY, width: self.frame.width, height: contentViewH)
        let contentView = STContentView(frame: contentViewF, childsVC: self.childsVC, parentVC: self.parentVC)
        addSubview(contentView)
        
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
