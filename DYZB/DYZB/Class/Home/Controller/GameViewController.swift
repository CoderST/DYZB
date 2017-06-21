//
//  GameViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/26.
//  Copyright © 2016年 xiudo. All rights reserved.
//  游戏

import UIKit
// MARK:- 常量
private let sGameCellInIdentifier = "xGameCellInIdentifier"
private let sHeadInIdentifier = "xHeadInIdentifier"

private let sEdgeMargin : CGFloat = 10
private let sItemW : CGFloat = (sScreenW - 2 * sEdgeMargin) / 3
private let sItemH :CGFloat = sItemW * 5.5 / 5
// 组头部高度
private let sHeadHeight :CGFloat = 50
// 顶部常用head的高度
private let sTopHeadHeight :CGFloat = 90

class GameViewController: BaseViewController {
    
    // MARK:- 懒加载
    fileprivate lazy var gameVM : GameViewModel = GameViewModel()
    // 展示主界面的collectionView
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sItemW, height: sItemH)
        layout.headerReferenceSize = CGSize(width: sScreenW, height: sHeadHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: sEdgeMargin, bottom: 0, right: sEdgeMargin)
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: self!.view.bounds, collectionViewLayout: layout)
        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // 注册cell
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier : sGameCellInIdentifier)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sHeadInIdentifier)
        
        return collectionView;
        
        }()
    // 每组collectionView的headView
    fileprivate lazy var topHeadCollectionView : CollectionHeaderView = {
       let headView = CollectionHeaderView.collectionHeaderView()
        headView.titleLabel.text = "常用"
        headView.moreButton.isHidden = true
        headView.iconImageView.image = UIImage(named: "Img_orange")
        headView.frame = CGRect(x: 0, y: -(sHeadHeight + sTopHeadHeight), width: sScreenW, height: sTopHeadHeight)
        return headView
    }()
    // 推荐游戏
    fileprivate lazy var topGameOftenView : RecommendGameView = {
       
        let gameOftenView = RecommendGameView.creatRecommendGameView()
        
        gameOftenView.frame = CGRect(x: 0, y: -sTopHeadHeight, width: sScreenW, height: sTopHeadHeight)
        
        return gameOftenView
        
    }()

    // MARK:- 生命周期
    override func viewDidLoad() {
        baseContentView = collectionView
        
        view.addSubview(collectionView)
        
        collectionView.addSubview(topHeadCollectionView)
        
        collectionView.addSubview(topGameOftenView)
        
        collectionView.contentInset = UIEdgeInsets(top: sHeadHeight + sTopHeadHeight, left: 0, bottom: 0, right: 0)
        
        super.viewDidLoad()
        
        
        loadData()
    }

}

// MARK:- 网络请求
extension GameViewController{
    func loadData(){
        gameVM.requestGameData { () -> () in
            self.collectionView.reloadData()
            
            self.topGameOftenView.anchorGroups = Array(self.gameVM.gamesData[0..<10])
            
            self.endAnimation()
        }
    }
}

// MARK:- UICollectionViewDataSource
extension GameViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return gameVM.gamesData.count 
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let gameCell = collectionView.dequeueReusableCell(withReuseIdentifier: sGameCellInIdentifier, for: indexPath) as!CollectionGameCell
        gameCell.anchorGroup = gameVM.gamesData[indexPath.item]
        return gameCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sHeadInIdentifier, for: indexPath) as!CollectionHeaderView
        // 2.给HeaderView设置属性
        reusableView.titleLabel.text = "全部"
        reusableView.iconImageView.image = UIImage(named: "Img_orange")
        reusableView.moreButton.isHidden = true
        

        return reusableView
    }
    
}
