//
//  SearchHeadView.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import STRowLayout
fileprivate let searchHeadViewIdentifier  = "searchHeadViewIdentifier"
class SearchHeadView: UIView {

    fileprivate lazy var searchHeadVM : SearchHeadVM = SearchHeadVM()
    // 展示主界面的collectionView
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = STRowLayout()
        layout.delegate = self
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        // 设置数据源
//        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        
        // 注册cell
        collectionView.register(SearchHeadCell.self, forCellWithReuseIdentifier: searchHeadViewIdentifier)
        return collectionView;
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1 添加collectionView
        // 2 添加数据
        // 3 计算多少行来控制collectionView的高度
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchHeadView : STRowLayoutDelegate{
    func stLayout(_ stLayout: STRowLayout!, widthtForRowAt indexPath: IndexPath!) -> CGFloat {
        
        return 40
    }
    
    // Height of Item
    func heightForRow(atIndexPath stLayout: STRowLayout!) -> CGFloat{
        
        return 40
    }
    
    // Space of Colums
    func layoutcolumnSpacingStLayout(_ stLayout: STRowLayout!) -> CGFloat{
        
        return 10
    }
    
    // Space of Row
    func layoutRowSpacingStLayout(_ stLayout: STRowLayout!) -> CGFloat{
        
        return 10
    }
}
