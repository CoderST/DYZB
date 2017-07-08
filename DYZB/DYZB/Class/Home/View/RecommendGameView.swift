//
//  RecommendGameView.swift
//  DYZB
//
//  Created by xiudou on 16/9/24.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
// MARK:- cell标识
private let recommendGameViewCellIdentifier = "recommendGameViewCellIdentifier"
// MARK:- 常量
private let edgeInsetMargin : CGFloat = 10
class RecommendGameView: UIView {

    // MARK:- 控件属性
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK:- 属性
    
    // MARK:- 数据传递
    var anchorGroups : [BaseGameModel]?{
        didSet{

            // 如果有值在执行下面操作
            guard let anchorGrs = anchorGroups else{
                return
                
            }
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            // 1.移除前两组数据(最热,颜值的数据移除)
            anchorGroups?.removeFirst()
            anchorGroups?.removeFirst()
            
            // 添加一个更多模型
            let anch = AnchorGroup()
            anch.tag_name = "更多"
            anchorGroups?.append(anch)
            collectionView.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        backgroundColor = UIColor.green
        autoresizingMask = UIViewAutoresizing()
        
        // 注册cell
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: recommendGameViewCellIdentifier)
        
        // 给collectionView添加内边距
        collectionView.contentInset = UIEdgeInsets(top: 0, left: edgeInsetMargin, bottom: 0, right: edgeInsetMargin)
    }

}

// MARK:- 快速创建对象
extension RecommendGameView{
    
    class func creatRecommendGameView()->RecommendGameView{
        
        return Bundle.main.loadNibNamed("RecommendGameView", owner: nil, options: nil)!.first as!RecommendGameView
    }
}

// MARK:- UICollectionViewDataSource
extension RecommendGameView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anchorGroups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendGameViewCellIdentifier, for: indexPath) as! CollectionGameCell
        cell.anchorGroup = anchorGroups![indexPath.item]
        return cell
    }
}

// MARK:- UICollectionViewDataSource
extension RecommendGameView : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let anchorGrop = anchorGroups![indexPath.item]
        let recommendGameVC = RecommentGameViewController()
        recommendGameVC.baseGameModel = anchorGrop
        getNavigation().pushViewController(recommendGameVC, animated: true)
    }
}
