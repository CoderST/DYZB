//
//  STContentFlowLayout.swift
//  STPageTest
//
//  Created by xiudou on 2016/12/13.
//  Copyright © 2016年 CoderST. All rights reserved.
//

import UIKit

protocol STContentFlowLayoutDataSource : class{
    // 多少行
    func rowsInSTContentFlowLayout(_ contentFlowLayout: STContentFlowLayout) -> Int
    // 多少列
    func colsInSTContentFlowLayout(_ contentFlowLayout: STContentFlowLayout) -> Int
}

class STContentFlowLayout: UICollectionViewFlowLayout {

    fileprivate lazy var attributeArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    var prePageCount : Int = 0
    /// 最大宽度
    fileprivate lazy var maxWidth : CGFloat = 0
    
    weak var dataSource : STContentFlowLayoutDataSource?
    
    // 列数
    var cols : Int{
        
        get{
            
            return dataSource?.colsInSTContentFlowLayout(self) ?? 4
        }
    }
    
    // 行数
    var rows : Int{
        
        get{
            return dataSource?.rowsInSTContentFlowLayout(self) ?? 2
        }
    }
    
}

extension STContentFlowLayout {
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        
        guard let collectionview = collectionView else { return }
        
        let itemW : CGFloat = (collectionview.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat((cols - 1))) / CGFloat(cols)

        let itemH : CGFloat = (collectionview.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * minimumLineSpacing) / CGFloat(rows)
        
        // 1. 获取组
        let sections = collectionview.numberOfSections
        
        // 2. 获取每组多少个
        for section in 0..<sections{
            // 每组多少个items
            let items = collectionview.numberOfItems(inSection: section)
            // 每组多少页
//            let pageOfSection = items / itemsOfPage
            for item in 0..<items{
                // 2.1. 创建indexPath
                let indexPath = IndexPath(item: item, section: section)
                // 2.2. 创建Attribute
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                // 2.3. 计算attribute大小
                // 2.3.1. item在当前组第几页
                let page = item / (cols * rows)
                // 2.3.2. item在当前页的index下标值
                let index = item % (cols * rows)
                
                // 2.4.设置attr的frame
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(index / cols)
                let itemX = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index % cols)
                attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                // 2.5. 添加到数组
                attributeArray.append(attribute)
            }
            // 2.6. 重新计算下一组开始在第几页
            prePageCount += (items - 1) / (cols * rows) + 1
        }
        
        // 3.计算最大Y值
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
    }

}

extension STContentFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
     
        return attributeArray
    }
}

extension STContentFlowLayout {
    
    override var collectionViewContentSize : CGSize {
        
        
        return  CGSize(width: maxWidth, height: 0)
    }
}
