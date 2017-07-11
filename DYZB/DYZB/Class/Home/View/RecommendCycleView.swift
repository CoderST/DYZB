//
//  RecommendCycleView.swift
//  DYZB
//
//  Created by xiudou on 16/9/23.
//  Copyright © 2016年 xiudo. All rights reserved.
//  轮播图view

import UIKit
import SVProgressHUD
// MARK:- 常量
private let cycleCellIdentifier = "cycleCellIdentifier"

class RecommendCycleView: UIView {

    @IBOutlet weak var cyclePage: UIPageControl!
    // MARK:- 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:- 属性
    var cycleTime : Timer?

    var cycleModels : [CycleModel]?{
        didSet{
            
            guard let models = cycleModels else { return }
            
            collectionView.reloadData()
            
            // 3.默认滚动到中间某一个位置
            let indexPath = IndexPath(item: models.count * 10, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
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
        autoresizingMask = UIViewAutoresizing()
        
        
        // 注册Cell
        collectionView.register(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: cycleCellIdentifier)
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
        
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)!.first as!RecommendCycleView
    }
}

// MARK:- UICollectionViewDataSource
extension RecommendCycleView : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cycleCell = collectionView.dequeueReusableCell(withReuseIdentifier: cycleCellIdentifier, for: indexPath) as! CollectionCycleCell
        let cycleModel = cycleModels![indexPath.item % (cycleModels?.count ?? 0)]
        cycleCell.cycleModel = cycleModel
        return cycleCell
    }
    
}

// MARK:- UICollectionViewDelegate
extension RecommendCycleView : UICollectionViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 设置pageControl
        let offset = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        let currentPage = Int(offset / scrollView.bounds.width) % (cycleModels?.count ?? 1)
        cyclePage.currentPage = currentPage
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        removeTime()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTime()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        /*
         if UIApplication.shared.canOpenURL(url) == true{
         UIApplication.shared.openURL(url)
         }else{
         SVProgressHUD.showError(withStatus: "url失效")
         }
         */
        let model = cycleModels![indexPath.item % (cycleModels?.count ?? 0)]
        let id = model.id
        let downUrlString = "https://itunes.apple.com/cn/app/id\(id)/"
        guard let downUrl = URL(string: downUrlString) else { return }
        if UIApplication.shared.canOpenURL(downUrl) == true{
            UIApplication.shared.openURL(downUrl)
        }else{
            SVProgressHUD.showError(withStatus: "url失效")
        }

        print("-----")
    }
}

// MARK:- 定时器相关
extension RecommendCycleView {
    
    // 创建定时器
    fileprivate func addTime(){
        cycleTime = Timer(timeInterval: 3.0, target: self, selector: #selector(RecommendCycleView.scrollToNextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTime!, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func removeTime(){
        cycleTime?.invalidate()
        cycleTime = nil
    }
    
    @objc fileprivate func scrollToNextPage(){
        // 获取当前的偏移量
        let offSet = collectionView.contentOffset.x
        // 即将要滚动的偏移量
        let newOffSet = offSet + collectionView.bounds.width
        // 开始滚动
        collectionView.setContentOffset(CGPoint(x: newOffSet, y: 0), animated: true)
    }
}
