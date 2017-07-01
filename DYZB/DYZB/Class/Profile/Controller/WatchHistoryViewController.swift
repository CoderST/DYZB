//
//  WatchHistoryViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import SVProgressHUD
let WatchHistoryItemHeight : CGFloat = 120
fileprivate let watchHistoryIdentifier  = "watchHistoryIdentifier"
class WatchHistoryViewController: BaseViewController {

    fileprivate lazy var watchHistoryVM : WatchHistoryVM = WatchHistoryVM()
    
    // 展示主界面的collectionView
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sScreenW, height: WatchHistoryItemHeight)
//        layout.headerReferenceSize = CGSize(width: sScreenW, height: sHeadHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
//        layout.sectionInset = UIEdgeInsets(top: 0, left: sEdgeMargin, bottom: 0, right: sEdgeMargin)
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: sStatusBarH + sNavatationBarH, width: sScreenW, height: sScreenH - sStatusBarH - sNavatationBarH), collectionViewLayout: layout)
        // 设置数据源
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        // 注册cell
        collectionView.register(WatchHistoryCell.self, forCellWithReuseIdentifier: watchHistoryIdentifier)
        return collectionView;
        
        }()
    
    override func viewDidLoad() {
        
        baseContentView = collectionView
        
        super.viewDidLoad()

       view.addSubview(collectionView)
        
        watchHistoryVM.loadWatchHistoryDatas({ 
            self.collectionView.reloadData()
            self.endAnimation()
        }, { (message) in
           SVProgressHUD.showError(withStatus: message)
        }) { 
            
        }
    }
}

extension WatchHistoryViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return watchHistoryVM.watchHistoryModelFrameArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: watchHistoryIdentifier, for: indexPath) as! WatchHistoryCell
//        cell.gameCenterModel = watchHistoryVM.watchHistoryModelArray[indexPath.item]
        let watchHistoryModelFrame = watchHistoryVM.watchHistoryModelFrameArray[indexPath.item]
        cell.watchHistoryModelFrame = watchHistoryModelFrame
//        cell.contentView.backgroundColor = UIColor.randomColor()
        return cell
    }
}
