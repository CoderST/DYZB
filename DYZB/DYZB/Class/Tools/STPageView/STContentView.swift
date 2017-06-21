//
//  STContentView.swift
//  STPageView
//
//  Created by xiudou on 2016/12/5.
//  Copyright © 2016年 CoderST. All rights reserved.
//  内容的view

import UIKit
protocol STContentViewDelegate : class{
    /// 结束滚动时调用
    func stContentView(_ stContentView : STContentView, targetIndex : Int)
    /// 滚动过程时调用
    func stContentView(_ stContentView : STContentView, currentIndex : Int, targetIndex : Int, process : CGFloat)
}
private let stContentViewCellIdentifier = "stContentViewCellIdentifier"
class STContentView: UIView {


    // MARK:- 定义属性
    fileprivate var childsVC : [UIViewController]
    fileprivate var parentVC : UIViewController
    
    var sourceIndex : Int = 0
    var targetIndex : Int = 0

    
    // 是否是禁止状态
    fileprivate var isForbidScroll : Bool = false
    
    fileprivate var startDraggingOffsetX : CGFloat = 0
    
    weak var delegate : STContentViewDelegate?
    
    // MARK:- 懒加载
    fileprivate lazy var collectionView : UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height)
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: stContentViewCellIdentifier)
        return collectionView
        
    }()
    
    // MARK:- 自定义构造函数
    init(frame: CGRect, childsVC : [UIViewController], parentVC : UIViewController) {
        // 初始化前一定要给属性赋值,不然会报super dont init 错误
        self.parentVC = parentVC
        self.childsVC = childsVC
        super.init(frame: frame)
        
        stupUI()
        
        // cacheMenuTYpe
//        cacheMenuTYpe()
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
// MARK:- // 判断本地是否有用户点击menuType记录
extension STContentView {
    
//    func cacheMenuTYpe() {
//        // 判断本地是否有用户点击menuType记录
//        guard let cacheIndex = STNSUserDefaults.object(forKey: HOMETYPE) as? Int else { return }
//        enumerateIndex(cacheIndex)
//
//    }
    
    func enumerateIndex(_ index : Int){
        isForbidScroll = true
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
    }

}

// MARK:- 设置UI
extension STContentView {
    
    fileprivate func stupUI(){
        
        addSubview(collectionView)
        
        // 1 添加子控制器
        for (_, vc) in childsVC.enumerated(){
            parentVC.addChildViewController(vc)
//            vc.view.backgroundColor = UIColor.randomColor()
        }
    }
}

// MARK:- UICollectionViewDataSource
extension STContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return childsVC.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stContentViewCellIdentifier, for: indexPath)
        
        // 注意:在这里记录startDraggingOffsetX,因为在scrollViewWillBeginDragging记录开始值时,当快速滑动屏幕时候,scrollViewWillBeginDragging方法不调用,下面加上的100是纠正值,是经过我测试发现,快速移动时候,此处拿到的开始值和scrollViewWillBeginDragging里拿到的开始值有差值,最大我发现是80,所以在这里我加上100
//        let a = Int((collectionView.contentOffset.x) / 320)
//        startDraggingOffsetX = CGFloat(a) * collectionView.frame.size.width
        // 添加子控制器View
        let vc = childsVC[indexPath.item]
        vc.view.frame = cell.contentView.bounds
        // 如果一个控件被添加到父控件中,只要这里不是初始化(allock init),addSubview无数次也只会添加进去一次
        cell.contentView.addSubview(vc.view)
        return cell
    }

}

extension STContentView : UICollectionViewDelegate{
    
    // 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        startDraggingOffsetX = scrollView.contentOffset.x
    }
    
    
    // 拖动界面 手指离开屏幕会调用此方法
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        
        if !decelerate{
            contentViewEndScrollView()
        }else{
            scrollView.isScrollEnabled = false
        }
    }
    
    // 已经结束减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        scrollView.isScrollEnabled = true
        contentViewEndScrollView()
        
    }
    
    func contentViewEndScrollView(){
        guard  !isForbidScroll else { return }
        let endScrollViewIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        delegate?.stContentView(self, targetIndex: endScrollViewIndex)
    
        
    }
    
    // 实时滚动监听
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        // 0.判断是否是点击事件
//        if isForbidScroll { return }
//        
//        // 1.定义获取需要的数据
//        var progress : CGFloat = 0
//        var sourceIndex : Int = 0
//        var targetIndex : Int = 0
//        
//        // 2.判断是左滑还是右滑
//        let currentOffsetX = scrollView.contentOffset.x
//        let scrollViewW = scrollView.bounds.width
//        if currentOffsetX > startDraggingOffsetX { // 左滑
//            // 1.计算progress
//            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
//            
//            // 2.计算sourceIndex
//            sourceIndex = Int(currentOffsetX / scrollViewW)
//            
//            // 3.计算targetIndex
//            targetIndex = sourceIndex + 1
//            if targetIndex >= childsVC.count {
//                targetIndex = childsVC.count - 1
//            }
//            
//            // 4.如果完全划过去
//            if currentOffsetX - startDraggingOffsetX == scrollViewW {
//                progress = 1
//                targetIndex = sourceIndex
//            }
//        } else { // 右滑
//            // 1.计算progress
//            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
//            
//            // 2.计算targetIndex
//            targetIndex = Int(currentOffsetX / scrollViewW)
//            
//            // 3.计算sourceIndex
//            sourceIndex = targetIndex + 1
//            if sourceIndex >= childsVC.count {
//                sourceIndex = childsVC.count - 1
//            }
//        }
//        
//        // 3.将progress/sourceIndex/targetIndex传递给titleView
////        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
//        delegate?.stContentView(self, currentIndex: sourceIndex, targetIndex: targetIndex, process: progress)

        
        /********************************************/
        
//        let currentIndex = scrollView.contentOffset.x / scrollView.bounds.width
//        let leftIndex = Int(currentIndex)
//        let rightIndex = leftIndex + 1
//        guard currentIndex > 0 && rightIndex <  childsVC.count else {
//            return
//        }
//        let rightScale = currentIndex - CGFloat(leftIndex)
//        let leftScale = CGFloat(rightIndex) - currentIndex
//        if startDraggingOffsetX < scrollView.contentOffset.x { // 左滑动
//            delegate?.stContentView(self, currentIndex: leftIndex, targetIndex: rightIndex, process: rightScale)
//        }else{    // 右滑动
//            delegate?.stContentView(self, currentIndex: rightIndex, targetIndex: leftIndex, process: leftScale)
//        }
//        
        /********************************************/
        

        guard startDraggingOffsetX != scrollView.contentOffset.x && !isForbidScroll else { return }
        
        // 1.定义targetIndex/progress
        var targetIndex = 0
        var progress : CGFloat = 0.0
        
        // 2.给targetIndex/progress赋值
        let currentIndex = Int(startDraggingOffsetX / scrollView.bounds.width)
//        print("ppppppppppppp",startDraggingOffsetX,scrollView.contentOffset.x)
        if startDraggingOffsetX < scrollView.contentOffset.x { // 左滑动
            targetIndex = currentIndex + 1
            if targetIndex > childsVC.count - 1 {
                targetIndex = childsVC.count - 1
            }
            
            progress = (scrollView.contentOffset.x - startDraggingOffsetX) / scrollView.bounds.width
        } else { // 右滑动
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            
            progress = (startDraggingOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        // 3.通知代理
        delegate?.stContentView(self, currentIndex: currentIndex, targetIndex: targetIndex, process: progress)
    }

    }


// MARK:- STTitlesViewDelegate
extension STContentView : STTitlesViewDelegate {
    
    func stTitlesView(_ stTitlesView: STTitlesView, toIndex: Int) {
        isForbidScroll = true
        let indexPath = IndexPath(item: toIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
