//
//  PageContentView.swift
//  DYZB
//
//  Created by xiudou on 16/9/15.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

// MARK:- 协议
protocol PageContentViewDelegate : class{
    func pageContentView(_ pageContentView:PageContentView,progress:CGFloat,originalIndex:Int,targetIndex:Int)
}

// MARK:- 常量
private let collectionViewIdentifier = "collectionViewIdentifier"

class PageContentView: UIView {
    
    // MARK:- 定义属性
    fileprivate weak var parentViewController : UIViewController?
    fileprivate var childVcs : [UIViewController]
    fileprivate var startOffset_x : CGFloat = 0
    fileprivate var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    
    // MARK:- 懒加载
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
       
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewIdentifier)
        
        return collectionView
        
    }()

    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController?) {
        self.parentViewController = parentViewController
        self.childVcs = childVcs
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- 设置UI
extension PageContentView{
    
    fileprivate func setupUI(){
        for vc in childVcs{
            
            parentViewController?.addChildViewController(vc)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
        

        
    }
    
}

// MARK:- UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return childVcs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIdentifier, for: indexPath)
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let viewController = childVcs[indexPath.item]
        cell.contentView.addSubview(viewController.view)
        viewController.view.frame = cell.contentView.bounds
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate{
    // 将要拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
         isForbidScrollDelegate = false
        
        startOffset_x = scrollView.contentOffset.x
    }
    
    
    // 实时滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScrollDelegate {return}
        
        var progress :CGFloat = 0
        var originalIndex = 0
        var targetIndex = 0
        let scrollowWidth : CGFloat = scrollView.frame.size.width
        
        let currentOffset_x = scrollView.contentOffset.x
        
        progress = currentOffset_x
        if (currentOffset_x > startOffset_x){  // 左滑
            // 计算progress
            progress = currentOffset_x / scrollowWidth - floor(currentOffset_x / scrollowWidth)
            // 计算originalIndex
            originalIndex = Int(currentOffset_x / scrollowWidth)
            // 计算currentIndex
            targetIndex = originalIndex + 1
            
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
            
            // 完全划过去
            if (currentOffset_x - startOffset_x == scrollowWidth){
                progress = 1.0
                targetIndex = originalIndex
            }
        }else{
            progress = 1 - ( currentOffset_x / scrollowWidth - floor(currentOffset_x / scrollowWidth))
            
            targetIndex = Int(currentOffset_x / scrollowWidth)
            
            originalIndex = targetIndex + 1
            
        }
        // 告诉代理
        delegate?.pageContentView(self, progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
        
    }
    
}


extension PageContentView{
    /**
     暴露给外界的函数
     */
    func setCurrentIndex(_ currentIndex:Int){
        isForbidScrollDelegate = true
        let offset_X = frame.width * CGFloat(currentIndex)
        collectionView.setContentOffset(CGPoint(x: offset_X, y: 0), animated: false)
    }
}




