//
//  ProfileViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/30.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
fileprivate let headViewHeight : CGFloat = sScreenW * 5 / 6
fileprivate let ProfileCellIdentifier  = "ProfileCellIdentifier"
class ProfileViewController: UIViewController {
    
    // MARK:- 懒加载
    fileprivate lazy var headView : ProfileHeadView = {
       
        let headView = ProfileHeadView()
        headView.frame = CGRect(x: 0, y: -headViewHeight, width: sScreenW, height: headViewHeight)
        return headView
        
    }()
    
    fileprivate lazy var profileVM : ProfileViewModel = ProfileViewModel()
    
    
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sScreenW, height: 44)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y:0, width: sScreenW, height: sScreenH), collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: headViewHeight, left: 0, bottom: 0, right: 0)

        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        
        // 注册cell
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCellIdentifier)
        
        return collectionView;
        
        }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        setupProfileDatas()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
}


// MARK:- 设置UI
extension ProfileViewController {
    
    fileprivate func setupUI() {
        // 添加collectionView
        view.addSubview(collectionView)
        // 添加collectionView上面的headView
        collectionView.addSubview(headView)
    }
}

// MARK:- 主数据
extension ProfileViewController {
    // 本地数据
    fileprivate func setupProfileDatas(){
        
        profileVM.loadProfileDatas({ 
            if let user = self.profileVM.user{
                self.headView.user = user
            }
            self.collectionView.reloadData()
        }, { (message) in
            debugLog(message)
        }) { 
            debugLog("失败")
        }
    }

}


extension ProfileViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return profileVM.groupDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let group = profileVM.groupDatas[section]
        return group.groupModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCellIdentifier, for: indexPath) as! ProfileCell
        let group = profileVM.groupDatas[indexPath.section]
        let profileModel = group.groupModels[indexPath.item]
        cell.profileModel = profileModel
        return cell
    }
}

extension ProfileViewController : UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugLog(scrollView.contentOffset.y)
        // 禁止下拉
        if scrollView.contentOffset.y <= -headViewHeight {
            scrollView.contentOffset.y = -headViewHeight
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = profileVM.groupDatas[indexPath.section]
        let profileModel = group.groupModels[indexPath.item]
        if let desVC = profileModel.targetClass as? UIViewController.Type {
            let vc = desVC.init()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 组间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
}

