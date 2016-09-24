//
//  RecommendCycleView.swift
//  DYZB
//
//  Created by xiudou on 16/9/23.
//  Copyright © 2016年 xiudo. All rights reserved.
//  轮播图view

import UIKit
// MARK:- 常量
private let cycleCellIdentifier = "cycleCellIdentifier"

class RecommendCycleView: UIView {

    @IBOutlet weak var cyclePage: UIPageControl!
    // MARK:- 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:- 属性
    var cycleTime : NSTimer?

    var cycleModels : [CycleModel]?{
        didSet{
            
            guard let models = cycleModels else { return }
            
            collectionView.reloadData()
            
            // 3.默认滚动到中间某一个位置
            let indexPath = NSIndexPath(forItem: models.count * 10, inSection: 0)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
            
            // 设置pageControl
            cyclePage.numberOfPages = models.count
            
            // 定时器操作
            removeTime()
            addTime()

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置该控件不随着父控件的拉伸而拉伸
        autoresizingMask = .None
        
        
        // 注册Cell
        collectionView.registerNib(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: cycleCellIdentifier)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = collectionView.collectionViewLayout as!UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = collectionView.bounds.size
    }
    
}
// MARK:- 快速创建RecommendCycleView
extension RecommendCycleView{
    class func creatRecommendCycleView()-> RecommendCycleView{
        
        return NSBundle.mainBundle().loadNibNamed("RecommendCycleView", owner: nil, options: nil).first as!RecommendCycleView
    }
}

// MARK:- UICollectionViewDataSource
extension RecommendCycleView : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cycleCell = collectionView.dequeueReusableCellWithReuseIdentifier(cycleCellIdentifier, forIndexPath: indexPath) as! CollectionCycleCell
        print("----",[indexPath.item % cycleModels!.count])
        let cycleModel = cycleModels![indexPath.item % (cycleModels?.count ?? 0)]
        cycleCell.cycleModel = cycleModel
        return cycleCell
    }
    
}

// MARK:- UICollectionViewDelegate
extension RecommendCycleView : UICollectionViewDelegate{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 设置pageControl
        let offset = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        let currentPage = Int(offset / scrollView.bounds.width) % (cycleModels?.count ?? 1)
        cyclePage.currentPage = currentPage
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        removeTime()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTime()
    }
}

// MARK:- 定时器相关
extension RecommendCycleView {
    
    // 创建定时器
    private func addTime(){
        cycleTime = NSTimer(timeInterval: 3.0, target: self, selector: "scrollToNextPage", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(cycleTime!, forMode: NSRunLoopCommonModes)
    }
    
    private func removeTime(){
        cycleTime?.invalidate()
        cycleTime = nil
    }
    
    @objc private func scrollToNextPage(){
        print("-------")
        // 获取当前的偏移量
        let offSet = collectionView.contentOffset.x
        // 即将要滚动的偏移量
        let newOffSet = offSet + collectionView.bounds.width
        // 开始滚动
        collectionView.setContentOffset(CGPointMake(newOffSet, 0), animated: true)
    }
}
