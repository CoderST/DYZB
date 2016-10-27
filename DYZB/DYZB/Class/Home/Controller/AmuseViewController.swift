//
//  AmuseViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//  娱乐

import UIKit
/// 顶部head的高度
private let sHeadViewHeight : CGFloat = 200
class AmuseViewController: BaseAnchorViewController {
    
    
    // MARK:- 懒加载
    private lazy var amuseVM = AmuseViewModel()
    // collectionView顶部head
    private lazy var amuseMenuView : AmuseMenuView = {
        let amuseMenuView = AmuseMenuView.creatAmuseMenuView()
        // 一定要设置autoresizingMask,不然界面很牛逼哦~~
        amuseMenuView.autoresizingMask = .None
        amuseMenuView.frame = CGRect(x: 0, y: -sHeadViewHeight, width: sScreenW, height: sHeadViewHeight)
        return amuseMenuView
    }()
}

extension AmuseViewController {
    override func setupUI() {
        super.setupUI()
        
        baseContentView = collectionView
        
        collectionView.addSubview(amuseMenuView)
        collectionView.contentInset = UIEdgeInsets(top: sHeadViewHeight, left: 0, bottom: 0, right: 0)
        
        
        loadAmuseDates()
    }

}

extension AmuseViewController {
    
    func loadAmuseDates(){
        
        amuseVM.loadAmuseDates { () -> () in
            self.recommendViewModel.anchorGroups = self.amuseVM.anchorGroups
            self.collectionView.reloadData()
            var tempGroups = self.amuseVM.anchorGroups
            tempGroups.removeFirst()
            self.amuseMenuView.groups = tempGroups
            
            self.endAnimation()
            
        }
        
    }
}


