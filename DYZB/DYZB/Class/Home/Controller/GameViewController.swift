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
private let xitemW : CGFloat = (ScreenW - 2 * xEdgeMargin) / 3
private let xitemH :CGFloat = xitemW * 5.5 / 5
// 组头部高度
private let xHeadHeight :CGFloat = 50
// 顶部常用head的高度
private let xTopHeadHeight :CGFloat = 90

class GameViewController: UIViewController {
    
    // MARK:- 懒加载
    private lazy var gameVM : GameViewModel = GameViewModel()
    // 展示主界面的collectionView
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
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        // 注册cell
        collectionView.registerNib(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier : xGameCellInIdentifier)
        collectionView.registerNib(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: xHeadInIdentifier)
        
        return collectionView;
        
        }()
    // 每组collectionView的headView
    private lazy var topHeadCollectionView : CollectionHeaderView = {
       let headView = CollectionHeaderView.collectionHeaderView()
        headView.titleLabel.text = "常用"
        headView.moreButton.hidden = true
        headView.iconImageView.image = UIImage(named: "Img_orange")
        headView.frame = CGRect(x: 0, y: -(xHeadHeight + xTopHeadHeight), width: ScreenW, height: xTopHeadHeight)
        return headView
    }()
    // 推荐游戏
    private lazy var topGameOftenView : RecommendGameView = {
       
        let gameOftenView = RecommendGameView.creatRecommendGameView()
        
        gameOftenView.frame = CGRect(x: 0, y: -xTopHeadHeight, width: ScreenW, height: xTopHeadHeight)
        
        return gameOftenView
        
    }()

    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        
        collectionView.addSubview(topHeadCollectionView)
        
        collectionView.addSubview(topGameOftenView)
        
        collectionView.contentInset = UIEdgeInsets(top: xHeadHeight + xTopHeadHeight, left: 0, bottom: 0, right: 0)
        
        loadData()
    }

}

// MARK:- 网络请求
extension GameViewController{
    func loadData(){
        gameVM.requestGameData { () -> () in
            self.collectionView.reloadData()
            
            self.topGameOftenView.anchorGroups = Array(self.gameVM.gamesData[0..<10])
        }
    }
}

// MARK:- UICollectionViewDataSource
extension GameViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        print("gamesData = \(gameVM.gamesData.count)")
        return gameVM.gamesData.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let gameCell = collectionView.dequeueReusableCellWithReuseIdentifier(xGameCellInIdentifier, forIndexPath: indexPath) as!CollectionGameCell
        gameCell.anchorGroup = gameVM.gamesData[indexPath.item]
        return gameCell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: xHeadInIdentifier, forIndexPath: indexPath) as!CollectionHeaderView
        // 2.给HeaderView设置属性
        reusableView.titleLabel.text = "全部"
        reusableView.iconImageView.image = UIImage(named: "Img_orange")
        reusableView.moreButton.hidden = true
        

        return reusableView
    }
    
}
