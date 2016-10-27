//
//  AmuseMenuViewCell.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
private let sAmuseMenuCellIdentifier = "sAmuseMenuCellIdentifier"
class AmuseMenuViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var groups : [AnchorGroup]?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        
        collectionView.registerNib(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: sAmuseMenuCellIdentifier)
    }

}

extension AmuseMenuViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print(frame)
        collectionView.frame = contentView.bounds
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemW = collectionView.bounds.size.width / 4
        let itemH = collectionView.bounds.size.height / 2
        layout.itemSize = CGSize(width: itemW, height: itemH)
    }
}

extension AmuseMenuViewCell : UICollectionViewDataSource {
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{

            return  groups?.count ?? 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(sAmuseMenuCellIdentifier, forIndexPath: indexPath) as! CollectionGameCell
        cell.clipsToBounds = true
        cell.anchorGroup = groups![indexPath.item]
        return cell
    }

}
