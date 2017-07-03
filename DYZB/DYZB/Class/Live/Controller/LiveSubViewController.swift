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
        
//       collectionView.delegate = self
       loadMainData(cate_id)
        
        
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
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

//extension LiveSubViewController {
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let pan = scrollView.panGestureRecognizer
//        let velocity = pan.velocity(in: scrollView).y
//        if velocity < -5 {
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        } else if velocity > 5 {
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//        
//    }
//}
