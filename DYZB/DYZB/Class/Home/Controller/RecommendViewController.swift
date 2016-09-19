//
//  RecommendViewController.swift
//  DYZB
//
//  Created by xiudou on 16/9/19.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
// MARK:- 常量
private let column : CGFloat = 2  // 列数
private let margin : CGFloat = 10 // 列间距
private let itemWidth : CGFloat = (ScreenW - (column + 1) * margin) / (column) // 每一个item宽
private let itemNormalWidth : CGFloat = itemWidth * 3 / 4
private let itemPrettyWidth : CGFloat = itemWidth * 4 / 3

// section Head尺寸
private let headerViewH : CGFloat = 50

private let cellNormalIdentifier = "cellNormalIdentifier"
private let cellPrettyIdentifier = "cellPrettyIdentifier"
private let cellHeadIdentifier = "cellHeadIdentifier"

class RecommendViewController: UIViewController {

    // MARK:- 懒加载
    private lazy var collectionView : UICollectionView = {
       // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemNormalWidth)
        layout.headerReferenceSize = CGSize(width: ScreenW, height: headerViewH)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]

        // 注册cell
        collectionView.registerNib(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier : cellNormalIdentifier)
        collectionView.registerNib(UINib(nibName: "CollectionViewPrettyCell", bundle: nil), forCellWithReuseIdentifier : cellPrettyIdentifier)
        collectionView.registerNib(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellHeadIdentifier)
    
        return collectionView;
        
    }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置UI
        setupUI()
        
    }
}

// MARK:- 初始化UI
extension RecommendViewController{
    
    private func setupUI(){
        view.addSubview(collectionView)
    }
}

extension RecommendViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        
        return 4

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1{
            let prettyCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellPrettyIdentifier, forIndexPath: indexPath)
            return prettyCell
        }else{
            let normalCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellNormalIdentifier, forIndexPath: indexPath)
            return normalCell
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        // 1.取出section的HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: cellHeadIdentifier, forIndexPath: indexPath)
        
        return headerView
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 1 {
            print(itemNormalWidth,itemPrettyWidth)
            return CGSize(width: itemWidth, height: itemPrettyWidth)
        }
        
        return CGSize(width: itemWidth, height: itemNormalWidth)
    }
    
}
