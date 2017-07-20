//
//  XDPlanFlowLayout.swift
//  layout
//
//  Created by xiudou on 2017/4/26.
//  Copyright © 2017年 CoderST. All rights reserved.
//

import UIKit 

class XDPlanFlowLayout: UICollectionViewFlowLayout {
var naviHeight : CGFloat = 64
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool{
        
        return true
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?{
        //UICollectionViewLayoutAttributes：我称它为collectionView中的item（包括cell和header、footer这些）的《结构信息》
        //截取到父类所返回的数组（里面放的是当前屏幕所能展示的item的结构信息），并转化成不可变数组
        guard var superArray = super.layoutAttributesForElements(in: rect) else {
            print("superArray不存在")
            return nil
        }
        //创建存索引的数组，无符号（正整数），无序（不能通过下标取值），不可重复（重复的话会自动过滤）
        let noneHeaderSections = NSMutableIndexSet()
        //遍历superArray，得到一个当前屏幕中所有的section数组
        for attributes in superArray{
            
            if attributes.representedElementCategory == .cell{
                
                noneHeaderSections.add(attributes.indexPath.section)
            }
        }
        
        //遍历superArray，将当前屏幕中拥有的header的section从数组中移除，得到一个当前屏幕中没有header的section数组
        //正常情况下，随着手指往上移，header脱离屏幕会被系统回收而cell尚在，也会触发该方法
        for attributes in superArray{
            if attributes.representedElementKind == UICollectionElementKindSectionHeader{
                
                noneHeaderSections.remove(attributes.indexPath.section)
            }
        }
        
      
//        for (index,text) in 0..<noneHeaderSections.enumerated() {
//            //取到当前section中第一个item的indexPath
//            let indexPath = IndexPath(item: 0, section: index)
//            print("xxxxx",index,noneHeaderSections.count)
//            //获取当前section在正常情况下已经离开屏幕的header结构信息
//            let attributes = layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
//            
//            
//            //如果当前分区确实有因为离开屏幕而被系统回收的header
//            if attributes != nil {
//                //将该header结构信息重新加入到superArray中去
//                superArray.append(attributes!)
//            }
//        }
//        var stop:UnsafeMutablePointer<ObjCBool>
        noneHeaderSections.enumerate({ (idx, _) in
            let indexPath = IndexPath(item: 0, section: idx)
            print("xxxxx",index,noneHeaderSections.count)
            //获取当前section在正常情况下已经离开屏幕的header结构信息
            let attributes = layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
            
            
            //如果当前分区确实有因为离开屏幕而被系统回收的header
            if attributes != nil {
                //将该header结构信息重新加入到superArray中去
                superArray.append(attributes!)
            }
        })
        
        for attributes in superArray{
            //如果当前item是header
            if attributes.representedElementKind == UICollectionElementKindSectionHeader{
                //得到当前header所在分区的cell的数量
                let numberOfItemsInSection = collectionView!.numberOfItems(inSection: attributes.indexPath.section)
                //得到第一个item的indexPath
                let firstItemIndexPath = IndexPath(item: 0, section: attributes.indexPath.section)
                //得到最后一个item的indexPath
                let itemNumber = max(0, numberOfItemsInSection - 1)
                let lastItemIndexPath = IndexPath(item: itemNumber, section: attributes.indexPath.section)
                //得到第一个item和最后一个item的结构信息
                let firstItemAttributes : UICollectionViewLayoutAttributes?
                let lastItemAttributes : UICollectionViewLayoutAttributes?
                if (numberOfItemsInSection > 0){
                    //cell有值，则获取第一个cell和最后一个cell的结构信息
                    firstItemAttributes = layoutAttributesForItem(at: firstItemIndexPath)
                    lastItemAttributes = layoutAttributesForItem(at: lastItemIndexPath )
                }else
                {
                    //cell没值,就新建一个UICollectionViewLayoutAttributes
                    firstItemAttributes = UICollectionViewLayoutAttributes()
                    //然后模拟出在当前分区中的唯一一个cell，cell在header的下面，高度为0，还与header隔着可能存在的sectionInset的top
                    let y = attributes.frame.maxY + sectionInset.top
                    firstItemAttributes!.frame = CGRect(x: 0, y: y, width: 0, height: 0)
                    //因为只有一个cell，所以最后一个cell等于第一个cell
                    lastItemAttributes = firstItemAttributes
                }

                
                //获取当前header的frame
                var rect = attributes.frame
                //当前的滑动距离 + 因为导航栏产生的偏移量，默认为64（如果app需求不同，需自己设置）
                let offset = collectionView!.contentOffset.y + naviHeight
                //第一个cell的y值 - 当前header的高度 - 可能存在的sectionInset的top
                let headerY = firstItemAttributes!.frame.origin.y - rect.size.height - sectionInset.top
                //哪个大取哪个，保证header悬停
                //针对当前header基本上都是offset更加大，针对下一个header则会是headerY大，各自处理
                let maxY = max(offset,headerY)
                //最后一个cell的y值 + 最后一个cell的高度 + 可能存在的sectionInset的bottom - 当前header的高度
                //当当前section的footer或者下一个section的header接触到当前header的底部，计算出的headerMissingY即为有效值
                let headerMissingY =  lastItemAttributes!.frame.maxY + sectionInset.bottom - rect.size.height
                //给rect的y赋新值，因为在最后消失的临界点要跟谁消失，所以取小
                rect.origin.y = min(maxY,headerMissingY)
                //给header的结构信息的frame重新赋值
                attributes.frame = rect
                
                //如果按照正常情况下,header离开屏幕被系统回收，而header的层次关系又与cell相等，如果不去理会，会出现cell在header上面的情况
                //通过打印可以知道cell的层次关系zIndex数值为0，我们可以将header的zIndex设置成1，如果不放心，也可以将它设置成非常大，这里随便填了个7
                attributes.zIndex = 7
            }
        }
        
        return superArray
    }
}
