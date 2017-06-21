//
//  LiveSubViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/19.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class LiveSubViewController: BaseAnchorViewController {

    
    // MARK:- 懒加载
    fileprivate lazy var liveViewModel : LiveViewModel  = LiveViewModel()
    
    // 接收的ID
    var cate_id : Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupLiveViewControllerUI()
        
        
       loadMainData(cate_id)
        
    }
    func setupLiveViewControllerUI() {
        
        super.setupUI()
        baseContentView = collectionView
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize.zero
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
    }
    
    func loadMainData(_ cate_id : Int) {
        
        liveViewModel.loadLiveMainDatas(cate_id, { 
            self.recommendViewModel.anchorGroups = self.liveViewModel.anchorGroups
            
            self.collectionView.reloadData()
            
            self.endAnimation()
        })
        
    }

}
