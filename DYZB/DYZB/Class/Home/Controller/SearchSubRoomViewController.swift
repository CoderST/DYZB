//
//  SearchSubRoomViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/29.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import SVProgressHUD
// MARK:- 常量
// 每组head
fileprivate let sSectionHeadInIdentifier = "sSectionHeadInIdentifier"
// 分类
fileprivate let sCateCellInIdentifier = "xGameCellInIdentifier"
// 主播
fileprivate let sAnchorIdentifier = "sSearchSubRoomIdentifier"
// 直播
fileprivate let sRoomIdentifier = "sRoomIdentifier"

// 组头部高度
fileprivate let sHeadHeight :CGFloat = 50
fileprivate let sEdgeMargin : CGFloat = 10
class SearchSubRoomViewController: BaseViewController {
    
    // MARK:- 懒加载
    fileprivate lazy var searchRoomVM : SearchRoomVM  = SearchRoomVM()
        
    // 展示主界面的collectionView
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: sScreenW, height: sHeadHeight)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: sEdgeMargin, bottom: 0, right: sEdgeMargin)
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: self!.view.bounds, collectionViewLayout: layout)
        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // 注册cell
        // 每组head
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sSectionHeadInIdentifier)
        // 分类->游戏
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier : sCateCellInIdentifier)
        // 主播
        collectionView.register(SearchAnchorCell.self, forCellWithReuseIdentifier: sAnchorIdentifier)
        // 直播
        collectionView.register(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier : sRoomIdentifier)
        
        return collectionView;
        
        }()
    
    override func viewDidLoad() {
        
        baseContentView = collectionView
        
        view.addSubview(collectionView)
        
        super.viewDidLoad()
        
        loadMainData()
        
    }
    
    
    func loadMainData() {
        searchRoomVM.loadSearchRoomDatas({
            self.collectionView.reloadData()
            
            //            self.topGameOftenView.anchorGroups = Array(self.gameVM.gamesData[0..<10])
            self.collectionView.reloadData()
            self.endAnimation()
            
        }) { (message) in
            SVProgressHUD.showError(withStatus: message)
        }
        
    }
}

// MARK:- UICollectionViewDataSource
extension SearchSubRoomViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return searchRoomVM.searchRoomGroupArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let searchGroup = searchRoomVM.searchRoomGroupArray[section]
        print("mmmmmm",section,searchGroup.searchRoomModelGroup.count)
        return searchGroup.searchRoomModelGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let searchGroup = searchRoomVM.searchRoomGroupArray[indexPath.section]
        let searchModel = searchGroup.searchRoomModelGroup[indexPath.item]
        if indexPath.section == 0{
            let cateCell = collectionView.dequeueReusableCell(withReuseIdentifier: sCateCellInIdentifier, for: indexPath) as!CollectionGameCell
                    cateCell.searchRoomModel = searchModel
            return cateCell

        }else if indexPath.section == 1{
            let anchorCell = collectionView.dequeueReusableCell(withReuseIdentifier: sAnchorIdentifier, for: indexPath) as!SearchAnchorCell
            //        gameCell.anchorGroup = gameVM.gamesData[indexPath.item]
            anchorCell.contentView.backgroundColor = UIColor.red
            return anchorCell

        }else{
            let roomCell = collectionView.dequeueReusableCell(withReuseIdentifier: sRoomIdentifier, for: indexPath) as!CollectionViewNormalCell
            //        gameCell.anchorGroup = gameVM.gamesData[indexPath.item]
            return roomCell

        }
        
  }
    
}

extension SearchSubRoomViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sSectionHeadInIdentifier, for: indexPath) as!CollectionHeaderView
        // 2.给HeaderView设置属性 reusableViewTitle
        
        let searchGroup = searchRoomVM.searchRoomGroupArray[indexPath.section]
        let searchModel = searchGroup.searchRoomModelGroup[indexPath.item]
        
        reusableView.titleLabel.text = searchModel.reusableViewTitle
        reusableView.iconImageView.image = UIImage(named: "Img_orange")
        reusableView.moreButton.isHidden = true
        
        
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let searchGroup = searchRoomVM.searchRoomGroupArray[indexPath.section]
        let searchModel = searchGroup.searchRoomModelGroup[indexPath.item]
     
        return CGSize(width: searchModel.width, height: searchModel.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        if section == 1{
            
            return 10
        }else{
            return 0
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
//        return CGSize(width: sScreenW, height: 50)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
//        return CGSize(width: sScreenW, height: 0.00001)
//    }
}
