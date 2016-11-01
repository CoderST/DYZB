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
 let sItemWidth : CGFloat = (sScreenW - (sColumn + 1) * sMargin) / (sColumn)
// 最热item宽度
 let sItemNormalWidth : CGFloat = sItemWidth * 3 / 4
// 颜值item宽度
 let sItemPrettyWidth : CGFloat = sItemWidth * 4 / 3
// section Head尺寸
 let sHeaderViewH : CGFloat = 50

// 最热cell标识
private let sCellNormalIdentifier = "cellNormalIdentifier"
// 颜值cell标识
private let sCellPrettyIdentifier = "cellPrettyIdentifier"
// cellHead标识
private let sCellHeadIdentifier = "cellHeadIdentifier"
class BaseAnchorViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        

    }
    
    // MARK:- 懒加载
     lazy var recommendViewModel : RecommendViewModel = RecommendViewModel()
    
     lazy var collectionView : UICollectionView = {[weak self] in
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

extension BaseAnchorViewController {
    
    override func setupUI(){
        
        baseContentView = collectionView
        
        view.addSubview(collectionView)
        
        super.setupUI()
    }
}

extension BaseAnchorViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        
        return recommendViewModel.anchorGroups.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let anchorGroup = recommendViewModel.anchorGroups[section]
        
        return anchorGroup.anchors.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 取出对应组
                let anchorGroup = recommendViewModel.anchorGroups[indexPath.section]
                let anchorModel = anchorGroup.anchors[indexPath.item]
        var cell : CollectionBaseCell!
        
        cell = collectionView.dequeueReusableCellWithReuseIdentifier(sCellNormalIdentifier, forIndexPath: indexPath) as! CollectionViewNormalCell
        // 传递模型
        cell.anchorModel = anchorModel
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        // 1.取出section的HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: sCellHeadIdentifier, forIndexPath: indexPath) as!CollectionHeaderView
                headerView.anchorGroup = recommendViewModel.anchorGroups[indexPath.section]
        return headerView
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: sItemWidth, height: sItemNormalWidth)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let anchorGroup = recommendViewModel.anchorGroups[indexPath.section]
        let anchorModel = anchorGroup.anchors[indexPath.item]

        let roomID = anchorModel.room_id
         anchorModel.isVertical == 0 ? gameAnchorVC() : showAnchorVC(roomID)
    }
    
    func showAnchorVC(room_id : Int64){
        let showVC = ShowAnchorViewController()
        showVC.room_id = room_id
        presentViewController(showVC, animated: true, completion: nil)
//        navigationController?.pushViewController(showVC, animated: true)
    }
    
    func gameAnchorVC(){
        let gameVC = GameAnchorViewController()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
}