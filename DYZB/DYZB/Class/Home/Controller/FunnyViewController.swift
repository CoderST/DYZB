//
//  FunnyViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//  趣玩

import UIKit

class FunnyViewController: BaseAnchorViewController {

    // MARK:- 懒加载
    fileprivate lazy var funnyViewModel : FunnyViewModel  = FunnyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFunnyViewControllerUI()
    }

}

extension FunnyViewController {
    
    // 重写父类方法
     func setupFunnyViewControllerUI() {
        // 实现父类方法
        super.setupUI()
        
        baseContentView = collectionView
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize.zero
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        loadData()
    }
}

extension FunnyViewController {
    
    func loadData(){
        funnyViewModel.loadFunnyDatas { () -> () in
            self.recommendViewModel.anchorGroups = self.funnyViewModel.anchorGroups
            
            self.collectionView.reloadData()
            
            self.endAnimation()
        }
    }
}


