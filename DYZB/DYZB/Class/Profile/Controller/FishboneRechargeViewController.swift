//
//  FishboneRechargeViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/4.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let columns : CGFloat = 3
fileprivate let leftMargin : CGFloat = 15
fileprivate let rightMargin : CGFloat = leftMargin
fileprivate let centerMargin : CGFloat = 20
fileprivate let FishboneRechargeCellIdentifier = "FishboneRechargeCellIdentifier"
class FishboneRechargeViewController: UIViewController {

    fileprivate lazy var fishboneRechargeVM : FishboneRechargeVM = FishboneRechargeVM()
    
    fileprivate lazy var fishboneRechargBottomView : FishboneRechargBottomView = FishboneRechargBottomView()
    
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        
        let width = (sScreenW - leftMargin - rightMargin - (columns - 1 ) * centerMargin) / columns
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = centerMargin
        layout.minimumLineSpacing = 20
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y:sStatusBarH + sNavatationBarH + 40, width: sScreenW, height: sScreenH - (sStatusBarH + sNavatationBarH + 40)), collectionViewLayout: layout)
                collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // 设置数据源
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(r: 231, g: 231, b: 231)
        
        // 注册cell
        collectionView.register(FishboneRechargeCell.self, forCellWithReuseIdentifier: FishboneRechargeCellIdentifier)
        
        return collectionView;
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "鱼刺充值"
        view.addSubview(collectionView)
        view.addSubview(fishboneRechargBottomView)
        
        fishboneRechargBottomView.frame = CGRect(x: 0, y: sScreenH - 100 - 20, width: sScreenW, height: 100)
        
        stupData()
    }

}

extension FishboneRechargeViewController {
    
    func stupData(){
        
        fishboneRechargeVM.loadFishboneRechargeDatas({ 
            self.collectionView.reloadData()
        }, { (message) in
            
        }) { 
            
        }
    }
}

extension FishboneRechargeViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return fishboneRechargeVM.fishboneRechargeBigModel.fishboneRechargeModelArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FishboneRechargeCellIdentifier, for: indexPath) as! FishboneRechargeCell
        let fishboneRechargeModel = fishboneRechargeVM.fishboneRechargeBigModel.fishboneRechargeModelArray[indexPath.item]
        cell.fishboneRechargeModel = fishboneRechargeModel
        if fishboneRechargeModel.default_select == "1" {
            fishboneRechargBottomView.fishboneRechargeModel = fishboneRechargeModel
        }
        
        return cell
    }
}

extension FishboneRechargeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let cell = collectionView.cellForItem(at: indexPath) as? FishboneRechargeCell else  { return }
        let cells = collectionView.visibleCells as! [FishboneRechargeCell]
        for cell in cells{
            cell.boderView.isHidden = true
        }
        let fishboneRechargeModel = fishboneRechargeVM.fishboneRechargeBigModel.fishboneRechargeModelArray[indexPath.item]
        cell.didSelectedModelAction(fishboneRechargeModel)
        fishboneRechargBottomView.fishboneRechargeModel = fishboneRechargeModel
    }

}
