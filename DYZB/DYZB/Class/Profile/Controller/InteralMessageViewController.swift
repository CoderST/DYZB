//
//  InteralMessageViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/3.
//  Copyright © 2017年 xiudo. All rights reserved.
//  站内信

import UIKit
import SVProgressHUD
fileprivate let InteralMessageCellIdentifier  = "InteralMessageCellIdentifier"
class InteralMessageViewController: BaseViewController {
    
    fileprivate lazy var interalMessageVM : InteralMessageVM = InteralMessageVM()
    
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sScreenW, height: 44)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y:sStatusBarH + sNavatationBarH, width: sScreenW, height: sScreenH - (sStatusBarH + sNavatationBarH)), collectionViewLayout: layout)
//        collectionView.contentInset = UIEdgeInsets(top: headViewHeight, left: 0, bottom: 0, right: 0)
        
        // 设置数据源
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        
        // 注册cell
        collectionView.register(InteralMessageCell.self, forCellWithReuseIdentifier: InteralMessageCellIdentifier)
        
        return collectionView;
        
    }()
    
    override func viewDidLoad() {
        
        baseContentView = collectionView
        
        super.viewDidLoad()
        
        setupInteralMessageUI()
        
        setupInteralMessageDatas()
        
        
    }
}

extension InteralMessageViewController {
    
    fileprivate  func setupInteralMessageUI() {
        // 添加collectionView
        view.addSubview(collectionView)
    }
}

extension InteralMessageViewController {
    
    fileprivate func setupInteralMessageDatas() {
        
        interalMessageVM.loadInteralMessageDatas({
            self.collectionView.reloadData()
            self.endAnimation()
        }, { (message) in
            SVProgressHUD.showInfo(withStatus: message)
        }) {
            SVProgressHUD.showError(withStatus: "请求失败")
        }
    }
}

extension InteralMessageViewController : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
       return interalMessageVM.interalMessageModelArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InteralMessageCellIdentifier, for: indexPath) as! InteralMessageCell
        cell.contentView.backgroundColor = UIColor.randomColor()
//        let interalMessageModel = interalMessageVM.interalMessageModelArray[indexPath.item]
        return cell
    }
}

extension InteralMessageViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: sScreenW, height: 44)
    }
}
