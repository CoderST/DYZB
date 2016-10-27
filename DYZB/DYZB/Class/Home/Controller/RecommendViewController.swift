//
//  RecommendViewController.swift
//  DYZB
//
//  Created by xiudou on 16/9/19.
//  Copyright © 2016年 xiudo. All rights reserved.
//  推荐

import UIKit
// MARK:- 常量
/// 轮播图高度
private let sRecommendCycleHeight : CGFloat = sScreenW * 3 / 8
/// 推荐游戏高度
private let sRecommendGameHeight : CGFloat = 90
/// 颜值cell标识
private let sCellPrettyIdentifier = "cellPrettyIdentifier"

class RecommendViewController: BaseAnchorViewController {

    // MARK:- 懒加载
    // 轮播图的view
    private lazy var recommendCycleView : RecommendCycleView = {
        
        let recommendCycleView = RecommendCycleView.creatRecommendCycleView()
        // y = -recommendCycleHeight(因为设置了collectionView.contentInset)
        recommendCycleView.frame = CGRect(x: 0, y: -(sRecommendCycleHeight + sRecommendGameHeight), width: sScreenW, height: sRecommendCycleHeight)
        return recommendCycleView
        
    }()
    
    // 推荐游戏view
    private lazy var recommentGameView : RecommendGameView = {
       
        let recommentGameView = RecommendGameView.creatRecommendGameView()
        
        let recommentGameViewF = CGRect(x: 0, y: -sRecommendGameHeight, width: sScreenW, height: sRecommendGameHeight)
        recommentGameView.frame = recommentGameViewF
        return recommentGameView
        
    }()
    // MARK:- 生命周期
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // 设置UI
        setupUI()
        
        setupNetWork()
    }
}

// MARK:- 初始化UI
extension RecommendViewController{
    
     override func setupUI(){
        // 将collectionView添加到控制器的view中
        view.addSubview(collectionView)
        
        collectionView.registerNib(UINib(nibName: "CollectionViewPrettyCell", bundle: nil), forCellWithReuseIdentifier : sCellPrettyIdentifier)
        
        // 添加子控间
        collectionView.addSubview(recommendCycleView)
        collectionView.addSubview(recommentGameView)
        
        // 设置collectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: sRecommendCycleHeight + sRecommendGameHeight, left: 0, bottom: 0, right: 0)
    }
}

extension RecommendViewController{
    
    private func setupNetWork(){
        
        // 请求推荐数据
        recommendViewModel.request { () -> () in
            
            self.collectionView.reloadData()
            let anchorGroups = self.recommendViewModel.anchorGroups
            self.recommentGameView.anchorGroups = anchorGroups
        }
        
        // 请求轮播图数据
        recommendViewModel.requestCycleData { () -> () in
        
            self.recommendCycleView.cycleModels = self.recommendViewModel.cycleDatas
        }
        

    }
}

extension RecommendViewController{
    
    
     override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 取出对应组
        let anchorGroup = recommendViewModel.anchorGroups[indexPath.section]
        let anchorModel = anchorGroup.anchors[indexPath.item]
        var cell : CollectionBaseCell!
        if indexPath.section == 1{
             cell = collectionView.dequeueReusableCellWithReuseIdentifier(sCellPrettyIdentifier, forIndexPath: indexPath) as! CollectionViewPrettyCell
            cell.anchorModel = anchorModel
            return cell
        }else{
            return super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
        }
        
    }


    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: sItemWidth, height: sItemPrettyWidth)
        }
        
        return CGSize(width: sItemWidth, height: sItemNormalWidth)
    }
    
}
