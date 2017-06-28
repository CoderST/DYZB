//
//  SearchViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import STRowLayout
import UICollectionViewLeftAlignedLayout
fileprivate let itemHeight : CGFloat = 44
fileprivate let headViewHeight : CGFloat = 60
fileprivate let searchHeadIdentifier  = "searchHeadIdentifier"
fileprivate let searchIdentifier  = "searchIdentifier"
fileprivate let searchSectionHeadViewIdentifier = "searchSectionHeadViewIdentifier"
class SearchViewController: UIViewController {
    
    
    // MARK:- 懒加载
    fileprivate lazy var searchVM : SearchVM = SearchVM()
    
    fileprivate lazy var headView : SearchHeadView = {
       
        let headView = SearchHeadView()
        headView.frame = CGRect(x: 0, y: 0, width: sScreenW, height: headViewHeight)
        return headView
        
    }()
    
    
    // 展示主界面的collectionView
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewLeftAlignedLayout()
        //        layout.headerReferenceSize = CGSize(width: sScreenW, height: 44)
        layout.minimumLineSpacing = 2 * searchModelMargin
        layout.minimumInteritemSpacing = searchModelMargin
        // 这里有打印警告:::::因为设置sectionInset后宽度会报警告
        layout.sectionInset = UIEdgeInsets(top: searchModelMargin, left: searchModelMargin, bottom: searchModelMargin, right: searchModelMargin)
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.white
        
        // 注册cell
        collectionView.register(SearchHeadCell.self, forCellWithReuseIdentifier: searchHeadIdentifier)
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: searchIdentifier)
        collectionView.register(SearchSectionHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: searchSectionHeadViewIdentifier)
        return collectionView;
        
    }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(headView)
        view.addSubview(collectionView)
        
        let collectionViewY = headView.frame.maxY
        collectionView.frame = CGRect(x: 0, y: collectionViewY, width: sScreenW, height: sScreenH - collectionViewY)

        notificationCenter.addObserver(self, selector: #selector(DelHistory), name: NSNotification.Name(rawValue: sNotificationName_DelHistory), object: nil)
        notificationCenter.addObserver(self, selector: #selector(Dismiss), name: NSNotification.Name(rawValue: sNotificationName_Dismiss), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchVM.loadSearchDatas(nil) {
            self.collectionView.reloadData()
        }
    }
}

// MARK:- 通知事件
extension SearchViewController {
    func DelHistory() {
        // 清除数组数据
        searchVM.searchLocalModelArray.searchModelArray.removeAll()
        // 清除本地缓存数据
        userDefaults.removeObject(forKey: historyKey)
        userDefaults.synchronize()
        collectionView.reloadData()
    }
    
    func Dismiss() {
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- UICollectionViewDataSource
extension SearchViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
//        print("ssss",searchVM.searchArrayGroup.count)
        return searchVM.searchArrayGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let searchGroup = searchVM.searchArrayGroup[section]
//        print("count",searchGroup.searchModelArray.count)
        return searchGroup.searchModelArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        
        let searchGroup = searchVM.searchArrayGroup[indexPath.section]
        let modelFrame = searchGroup.searchModelArray[indexPath.item]
        
        if indexPath.section == 0{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchHeadIdentifier, for: indexPath) as! SearchHeadCell
            
            cell.searchFrame = modelFrame
            //            cell.contentView.backgroundColor = UIColor.red
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchIdentifier, for: indexPath) as! SearchCell
            
            cell.searchModel = modelFrame.searchModel
            
            //            cell.contentView.backgroundColor = UIColor.yellow
            return cell
        }
        
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension SearchViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let searchGroup = searchVM.searchArrayGroup[indexPath.section]
        let modelFrame = searchGroup.searchModelArray[indexPath.item]
        // 跳转界面
        print(modelFrame.searchModel.title)
        let title = modelFrame.searchModel.title
        
        
        searchVM.loadSearchDatas(title) {
            self.collectionView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: searchSectionHeadViewIdentifier, for: indexPath) as!SearchSectionHeadView
        // 2.给HeaderView设置属性
        
        if  indexPath.section == 0 {
//            reusableView.backgroundColor = .gray
            reusableView.title = "最近搜索"
            reusableView.isHiddenDelButton = false
        }else{
//            reusableView.backgroundColor = .yellow
            reusableView.title = "今日热搜"
            reusableView.isHiddenDelButton = true
        }
        
        
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        let searchGroup = searchVM.searchArrayGroup[section]
        if  section == 0 {
            if searchGroup.searchModelArray.count == 0 {
                return CGSize.zero
            }else{
                return CGSize(width: sScreenW, height: 44)
            }
        }else{
            if searchGroup.searchModelArray.count == 0 {
                return CGSize.zero
            }else{
                return CGSize(width: sScreenW, height: 44)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let searchGroup = searchVM.searchArrayGroup[indexPath.section]
        let modelFrame = searchGroup.searchModelArray[indexPath.item]
        
//        print(modelFrame.searchModel.title,modelFrame.cellSize)
        return modelFrame.cellSize
    }
    
}

