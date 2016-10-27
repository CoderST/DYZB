//
//  BaseAnchorViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
// MARK:- 常量
// 列数
private let sColumn : CGFloat = 2
// 列间距
private let sMargin : CGFloat = 10
// 每一个item宽
private let sItemWidth : CGFloat = (sScreenW - (sColumn + 1) * sMargin) / (sColumn)
// 最热item宽度
private let sItemNormalWidth : CGFloat = sItemWidth * 3 / 4
// 颜值item宽度
private let sItemPrettyWidth : CGFloat = sItemWidth * 4 / 3
// 轮播图高度
private let sRecommendCycleHeight : CGFloat = sScreenW * 3 / 8
// 推荐游戏高度
private let sRecommendGameHeight : CGFloat = 90
// section Head尺寸
private let sHeaderViewH : CGFloat = 50

// 最热cell标识
private let sCellNormalIdentifier = "cellNormalIdentifier"
// 颜值cell标识
private let sCellPrettyIdentifier = "cellPrettyIdentifier"
// cellHead标识
private let sCellHeadIdentifier = "cellHeadIdentifier"
class BaseAnchorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)

    }
    
    private lazy var collectionView : UICollectionView = {[weak self] in
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sItemNormalWidth, height: sItemPrettyWidth)
        layout.headerReferenceSize = CGSize(width: sScreenW, height: sHeaderViewH)
        layout.minimumInteritemSpacing = sMargin
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: sMargin, bottom: 0, right: sMargin)
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: self!.view.bounds, collectionViewLayout: layout)
        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        // 注册cell
        collectionView.registerNib(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier : sCellNormalIdentifier)
        collectionView.registerNib(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sCellHeadIdentifier)
        
        return collectionView;
        
        }()

}

extension BaseAnchorViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //        let anchorGroup = recommendViewModel.anchorGroups[section]
        
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 取出对应组
        //        let anchorGroup = recommendViewModel.anchorGroups[indexPath.section]
        //        let anchorModel = anchorGroup.anchors[indexPath.item]
        var cell : CollectionBaseCell!
        
        cell = collectionView.dequeueReusableCellWithReuseIdentifier(sCellNormalIdentifier, forIndexPath: indexPath) as! CollectionViewNormalCell
        // 传递模型
        //        cell.anchorModel = anchorModel
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        // 1.取出section的HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: sCellHeadIdentifier, forIndexPath: indexPath) as!CollectionHeaderView
        //        headerView.anchorGroup = recommendViewModel.anchorGroups[indexPath.section]
        return headerView
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: sItemWidth, height: sItemNormalWidth)
    }
    
}