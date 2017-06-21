//
//  STPageCollectionView.swift
//  STPageTest
//
//  Created by xiudou on 2016/12/13.
//  Copyright © 2016年 CoderST. All rights reserved.
//  表情视图

import UIKit

// MARK:- STPageCollectionView数据源方法
protocol STPageCollectionViewDataSource : class {
    /// 多少组
    func numberOfSectionsInSTPageCollectionView(_ pageCollectionView: STPageCollectionView) -> Int
    /// 每组多少item
    func pageCollectionView(_ pageCollectionView: STPageCollectionView, numberOfItemsInSection section: Int) -> Int
    /// 定义cell
    func pageCollectionView(_ pageCollectionView: STPageCollectionView, collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
}
// MARK:- STPageCollectionView代理
protocol STPageCollectionViewDelegate : class {
    func pageCollectionView(_ stPageCollectionView: STPageCollectionView, didSelectItemAt indexPath: IndexPath)
}

class STPageCollectionView: UIView {
    
    // MARK:- 定义属性
    // 接收属性
    fileprivate var titles : [String]
    fileprivate var style : STPageViewStyle
    fileprivate var isTitleInTop : Bool
    fileprivate var layout : STContentFlowLayout
    // 记录属性
    fileprivate var sourceIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    fileprivate var collectionView : UICollectionView!
    // 控件属性
    fileprivate var titleView : STTitlesView!
    fileprivate var pageControl : UIPageControl!
    // 数据源,代理
    weak var dataSource : STPageCollectionViewDataSource?
    weak var delegate : STPageCollectionViewDelegate?
    // 构造函数
    init(frame: CGRect, titles : [String], style : STPageViewStyle, isTitleInTop : Bool, layout : STContentFlowLayout) {
        self.titles = titles
        self.style = style
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 对外暴露的方法
extension STPageCollectionView {
    /**
     Class 注册cell
     */
    func registerClass(_ cellClass : AnyClass?, forCellWithReuseIdentifier : String) {
        
        
        collectionView.register(cellClass, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    /**
     UINib 注册cell
     */
    func registerNib(_ nib : UINib?, forCellWithReuseIdentifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    /**
     刷新
     */
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK:- 设置UI(titleView,UIPageControl,UICollectionView)
extension STPageCollectionView {
    
    fileprivate func setupUI() {
        
        // 1.创建titleView
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleViewHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleViewHeight)
        titleView = STTitlesView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        titleView.backgroundColor = style.titleViewBackgroundColor
        addSubview(titleView)
        
        // 2.创建UIPageControl
        let pageControlY = isTitleInTop ? (bounds.height - style.pageControlHeight) : (bounds.height - style.pageControlHeight - style.titleViewHeight)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: style.pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.backgroundColor = style.pageControlBackgroundColor
        pageControl.currentPageIndicatorTintColor = style.currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = style.pageIndicatorTintColor
        pageControl.numberOfPages = 4
        pageControl.isEnabled = false
        addSubview(pageControl)
        
        // 3.创建UICollectionView
        let collectionViewY = isTitleInTop ? style.titleViewHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleViewHeight - style.pageControlHeight)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        pageControl.backgroundColor = collectionView.backgroundColor
    }
    
}
// MARK:- UICollectionViewDataSource
extension STPageCollectionView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return dataSource?.numberOfSectionsInSTPageCollectionView(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        
        return dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        // 此处可以强制解包
        return dataSource!.pageCollectionView(self, collectionView: collectionView, cellForItemAtIndexPath: indexPath)
    }
    
}
// MARK:- UICollectionViewDelegate
extension STPageCollectionView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    // 停止惯性的处理
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        changePageControl()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate{
            changePageControl()
        }
    }
    
    func changePageControl(){
        
        // 1.取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        // 2.判断分组是否有发生改变
        if sourceIndexPath.section != indexPath.section {
            // 3.1.修改pageControl的个数
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            // 3.2.设置titleView位置
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            // 3.3.记录最新indexPath
            sourceIndexPath = indexPath
        }
        
        // 3.根据indexPath设置pageControl
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
    
}

extension STPageCollectionView : STTitlesViewDelegate {
    
    func stTitlesView(_ stTitlesView: STTitlesView, toIndex: Int) {
        
        let indexPath = IndexPath(item: 0, section: toIndex)
        print(indexPath.item,indexPath.section)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        //FIXME: scrollToItemAtIndexPath 方法滚动后没有回到正确的位置 
        print("pppppp",collectionView.contentOffset.x)
        changePageControl()
    }
}
