//
//  AmuseMenuView.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
// MARK:- 常量
private let sAmuseMenuIdentifier = "sAmuseMenuIdentifier"

private let sPageControlW : CGFloat = sScreenW
private let sPageControlH : CGFloat = 30


class AmuseMenuView: UIView {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var groups : [AnchorGroup]?{
        
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.registerNib(UINib(nibName: "AmuseMenuViewCell", bundle: nil), forCellWithReuseIdentifier: sAmuseMenuIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout  = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
    }

}

extension AmuseMenuView {
    
    class func creatAmuseMenuView()->AmuseMenuView{
        return NSBundle.mainBundle().loadNibNamed("AmuseMenuView", owner: nil, options: nil).first as! AmuseMenuView
        
    }
}

extension AmuseMenuView : UICollectionViewDataSource {
    
    // 需要展示几个item,
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        if groups == nil { return 0 }
        let pageNum = (groups!.count - 1) / 8 + 1
        pageControl.numberOfPages = pageNum
        
        return pageNum

    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(sAmuseMenuIdentifier, forIndexPath: indexPath) as! AmuseMenuViewCell
        setupCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setupCell(cell : AmuseMenuViewCell,indexPath : NSIndexPath){
        // 1  0 ~ 7
        // 2  8 ~ 15
        // 3  16 ~ 23
        // 取出对应的页面数据的个数传递给cell中的collectionView
        let startItem = indexPath.item * 8
        var endItem = (indexPath.item + 1) * 8 - 1
        // 处理越界问题
        if endItem > groups!.count - 1{
            endItem = groups!.count - 1
        }
        let tempGroup = Array(groups![startItem ... endItem])
//        print("temp = ",tempGroup.count)
        cell.groups = tempGroup
    }
}
