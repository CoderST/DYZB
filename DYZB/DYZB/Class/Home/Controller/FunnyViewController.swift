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
    private lazy var funnyViewModel : FunnyViewModel  = FunnyViewModel()
    

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//    }
//
}

extension FunnyViewController {
    
    override func setupUI() {
        super.setupUI()
        
        baseContentView = collectionView
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSizeZero
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        loadData()
    }
}

extension FunnyViewController {
    
    func loadData(){
        funnyViewModel.loadFunnyDatas { () -> () in
            let array = self.funnyViewModel.anchorGroups[0]
            print(array.anchors.count)
            self.recommendViewModel.anchorGroups = self.funnyViewModel.anchorGroups
            
            self.collectionView.reloadData()
            
            self.endAnimation()
        }
    }
}


