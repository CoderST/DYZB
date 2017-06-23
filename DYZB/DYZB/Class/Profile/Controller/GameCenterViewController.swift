//
//  GameCenterViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//  游戏中心

import UIKit
import SVProgressHUD
fileprivate let itemHeight : CGFloat = 100
fileprivate let gameCellIdentifier  = "gameCellIdentifier"
class GameCenterViewController: BaseViewController {

    fileprivate lazy var gameCenterVM : GameCenterVM = GameCenterVM()
    
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sScreenW, height: itemHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        // 设置数据源
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        // 注册cell
        collectionView.register(GameCenterCell.self, forCellWithReuseIdentifier: gameCellIdentifier)

        
        return collectionView;
        
        }()
    
    override func viewDidLoad() {
        
        baseContentView = collectionView
        view.addSubview(collectionView)
        setupData()
        super.viewDidLoad()
    }

}

extension GameCenterViewController {
    fileprivate func setupData(){
        gameCenterVM.loadGameCenterDatas({
            self.endAnimation()
            self.collectionView.reloadData()
        }, { (message) in
            SVProgressHUD.showInfo(withStatus: message)
        }) { 
            SVProgressHUD.showError(withStatus: "失败")
        }
    }
}

extension GameCenterViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return gameCenterVM.gameModelArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gameCellIdentifier, for: indexPath) as! GameCenterCell
        cell.gameCenterModel = gameCenterVM.gameModelArray[indexPath.item]
        return cell
    }
}
