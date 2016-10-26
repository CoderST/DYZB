//
//  GameViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/26.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
// MARK:- 常量
private let xGameCellInIdentifier = "xGameCellInIdentifier"
private let xHeadInIdentifier = "xHeadInIdentifier"

private let xEdgeMargin : CGFloat = 10
private let xitemW = (ScreenW - 2 * xEdgeMargin) / 3
private let xitemH = xitemW * 6 / 5
private let xHeadHeight :CGFloat = 50

class GameViewController: UIViewController {
    
    // MARK:- 懒加载
    private lazy var gameVM : GameViewModel = GameViewModel()
    private lazy var collectionView : UICollectionView = {[weak self] in
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: xitemW, height: xitemH)
        layout.headerReferenceSize = CGSize(width: ScreenW, height: xHeadHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: xEdgeMargin, bottom: 0, right: xEdgeMargin)
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: self!.view.bounds, collectionViewLayout: layout)
        // 设置数据源
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        // 注册cell
        collectionView.registerNib(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier : xGameCellInIdentifier)
        collectionView.registerNib(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: xHeadInIdentifier)
        
        return collectionView;
        
        }()

    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        
        loadData()
    }

}

// MARK:- 网络请求
extension GameViewController{
    func loadData(){
        gameVM.requestGameData { () -> () in
            self.collectionView.reloadData()
        }
    }
}

// MARK:- UICollectionViewDataSource
extension GameViewController : UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        print("gamesData = \(gameVM.gamesData.count)")
        return gameVM.gamesData.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let gameCell = collectionView.dequeueReusableCellWithReuseIdentifier(xGameCellInIdentifier, forIndexPath: indexPath) as!CollectionGameCell
        gameCell.anchorGroup = gameVM.gamesData[indexPath.item]
        return gameCell
    }
    
}
