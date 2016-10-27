//
//  PageTitlesView.swift
//  DYZB
//
//  Created by xiudou on 16/9/16.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
// MARK:- 协议
protocol PageTitlesViewDelegate : class {
    
    func pageTitlesView(pageTitlesView:PageTitlesView, index : Int)
}
// MARK:- 常量
private let scrollLineH : CGFloat = 2
private let colorNormal : (CGFloat, CGFloat ,CGFloat) = (85 ,85 ,85)
private let colorSelected : (CGFloat, CGFloat ,CGFloat) = (255 ,128 ,0)


class PageTitlesView: UIView {
    
    // MARK:- 定义属性
    private var titles : [String]
    private var currentIndex : Int = 0
    weak var delegate : PageTitlesViewDelegate?
    
    // MARK:- 懒加载
    /// scrollView
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    /// 底部的线
    private lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGrayColor()
        return bottomLine
    }()
    /// 底部滚动的横条
    private lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor(r: colorSelected.0, g: colorSelected.1, b: colorSelected.2)
        return scrollLine
    }()
/// 标题数组
    private lazy var titleLabels : [UILabel] = [UILabel]()
    
    // MARK:- 构造函数(override init)
    init(frame: CGRect,titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 初始化UI
extension PageTitlesView{
    
    private func setupUI(){
        
        // 添加 scrollView
        addSubview(scrollView)
        scrollView.frame = self.bounds
        
        // 添加label
        setupTitleLabels()
        
        // 设置底部线和滑块
        setupBottomLineAndScrollLine()
        
    }
    /**
     设置label尺寸和位置
     */
    private func setupTitleLabels(){
        
        let label_W = sScreenW / CGFloat(titles.count)
        let label_Y :CGFloat  = 0
        let label_H :CGFloat  = frame.size.height - scrollLineH
        
        for (index,title) in titles.enumerate(){
            let label = UILabel()
            titleLabels.append(label)
            scrollView .addSubview(label)
            // 设置属性
            label.tag = index
            label.text = title
            label.textColor = UIColor(r: colorNormal.0, g: colorNormal.1, b: colorNormal.2)
            label.textAlignment = .Center
            label.font = UIFont.systemFontOfSize(17)
            // 设置尺寸
            let label_X :CGFloat = CGFloat(index) * label_W
            label.frame = CGRect(x: label_X, y: label_Y, width: label_W, height: label_H)
            
            // 开启用户交互
            label.userInteractionEnabled = true
            // 创建手势
            let tap = UITapGestureRecognizer(target: self, action: "tapGestureRecognizer:")
            label.addGestureRecognizer(tap)
        }
    }
    
    private func setupBottomLineAndScrollLine(){
        
        // 底部的线
         scrollView.addSubview(bottomLine)
        bottomLine.frame = CGRect(x: 0, y: frame.size.height - scrollLineH, width: sScreenW, height: scrollLineH)
        
        guard let label = titleLabels.first else {return}
        label.textColor = UIColor(r: colorSelected.0, g: colorSelected.1, b: colorSelected.2)
        // 底部的滑块
        addSubview(scrollLine)
        scrollLine.frame = CGRect(x: label.frame.origin.x, y: label.frame.size.height, width: label.frame.size.width, height: scrollLineH)
    }
    
}

// MARK:- 监听label点击事件
extension PageTitlesView{
    @objc private func tapGestureRecognizer(tap : UIGestureRecognizer){
        
        // as后面更上?  因为如果是! 就不可以用guard
        guard let label = tap.view as? UILabel else {return}
        // 之前的label
        let oldLabel = titleLabels[currentIndex]
        oldLabel.textColor = UIColor(r: colorNormal.0, g: colorNormal.1, b: colorNormal.2)
        // 让点击的label变色
        label.textColor = UIColor(r: colorSelected.0, g: colorSelected.1, b: colorSelected.2)
        currentIndex = label.tag
        
        
        // 让滑块滚动
        let scrollLine_X = CGFloat(currentIndex) * label.frame.size.width
        UIView.animateWithDuration(0.2) {[weak self] () -> Void in
            self?.scrollLine.frame.origin.x = scrollLine_X
        }

        
        // 通知代理
        delegate?.pageTitlesView(self, index: currentIndex)
    }
}

extension PageTitlesView{
    
 
    func setPageTitlesView(progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        
        // 原来的label
        let originalLabel = titleLabels[originalIndex]
        // 目标label
        let targetLabel = titleLabels[targetIndex]
        
        // 滑块
        let moveRange = targetLabel.frame.origin.x - originalLabel.frame.origin.x
        let moveX = moveRange * progress
        scrollLine.frame.origin.x = originalLabel.frame.origin.x + moveX
        
        // 颜色变化的区间
        let rangeColor = (colorSelected.0 - colorNormal.0,colorSelected.1 - colorNormal.1,colorSelected.2 - colorNormal.2)

        // 改变label的颜色
        originalLabel.textColor = UIColor(r: colorSelected.0 - rangeColor.0 * progress, g: colorSelected.1 -  rangeColor.1 * progress, b:  colorSelected.2 - rangeColor.2 * progress)
        
        targetLabel.textColor = UIColor(r: rangeColor.0 * progress + colorNormal.0, g: rangeColor.1 * progress + colorNormal.1, b: rangeColor.2 * progress + colorNormal.2)
        
        currentIndex = targetIndex
        
    }
}
