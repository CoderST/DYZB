//
//  SearchViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let itemHeight : CGFloat = 44
fileprivate let searchIdentifier  = "searchIdentifier"
class SearchViewController: UIViewController {

    fileprivate lazy var searchVM : SearchVM = SearchVM()
    
    fileprivate lazy var dissmissButton : UIButton = {
       
        let dissmissButton = UIButton()
        dissmissButton.backgroundColor = UIColor.red
        return dissmissButton
    }()
    
    // 展示主界面的collectionView
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sScreenW, height: itemHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        // 设置数据源
        collectionView.dataSource = self
        //        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        // 注册cell
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: searchIdentifier)
        return collectionView;
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        collectionView.frame = CGRect(x: 0, y: 0, width: sScreenW, height: sScreenH)
        
        view.addSubview(collectionView)
        view.addSubview(dissmissButton)
        dissmissButton.frame = CGRect(x: 250, y: 60, width: 50, height: 50)
        dissmissButton.addTarget(self, action: #selector(dissmissButtonAction), for: .touchUpInside)
        
        searchVM.loadSearchDatas { 
            self.collectionView.reloadData()
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("zzzzzzzzz",collectionView.contentInset)
    }
    
    func dissmissButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return searchVM.searchArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchIdentifier, for: indexPath) as! SearchCell
        cell.contentView.backgroundColor = UIColor.randomColor()
        cell.searchModel = searchVM.searchArray[indexPath.item]
        return cell
    }
}
