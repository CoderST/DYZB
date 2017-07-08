//
//  RecommentGameSubViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/7.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class RecommentGameSubViewController: BaseAnchorViewController {
    
    // MARK:- 对外
    var id : String = ""
    var baseGameModel : BaseGameModel = BaseGameModel()
    
    fileprivate lazy var recommentGameVM : RecommentGameVM = RecommentGameVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecommentGameUI()
        
        if id == baseGameModel.tag_id {  // 全部
            
            recommentGameVM.loadRecommentGameAllDatas(tag_id: baseGameModel.tag_id, { 
                self.recommendViewModel.anchorGroups = self.recommentGameVM.anchorGroups
                
                self.collectionView.reloadData()
                
                self.endAnimation()
            }, { (message) in
                
            }, failCallBack: { 
                
            })
            
        }else{
            
            loadElseMainData(id)
        }
        
    }
}


extension RecommentGameSubViewController {
    
    func setupRecommentGameUI() {
        
        super.setupUI()
        baseContentView = collectionView
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize.zero
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
    }
}

extension RecommentGameSubViewController {
    func loadElseMainData(_ cate_id : String) {
        recommentGameVM.loadRecommentGameElseDatas(cate_id, { 
            self.recommendViewModel.anchorGroups = self.recommentGameVM.anchorGroups
            
            self.collectionView.reloadData()
            
            self.endAnimation()
        }, { (message) in
            
        }) { 
            
        }
    }
}
