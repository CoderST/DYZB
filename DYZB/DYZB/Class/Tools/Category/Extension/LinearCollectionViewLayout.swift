//
//  STProgressView.swift
//  STScrolPlay
//
//  Created by xiudou on 2017/7/30.
//  Copyright © 2017年 CoderST. All rights reserved.
//  横向滚动 放大缩小(中间为最大)

import UIKit

class LinearCollectionViewLayout: UICollectionViewFlowLayout {
    
    //元素宽度
    var itemWidth:CGFloat = 100
    //元素高度
    var itemHeight:CGFloat = 100
    
    //对一些布局的准备操作放在这里
    override func prepare() {
        super.prepare()
        //设置元素大小
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        //设置滚动方向
        self.scrollDirection = .horizontal
        //设置间距
        self.minimumLineSpacing = self.collectionView!.bounds.width / 2 -  itemWidth
        
        //设置内边距
        //左右边距为了让第一张图片与最后一张图片出现在最中央
        //上下边距为了让图片横行排列，且只有一行
        let left = (self.collectionView!.bounds.width - itemWidth) / 2
        let top = (self.collectionView!.bounds.height - itemHeight) / 2
        self.sectionInset = UIEdgeInsetsMake(top, left, top, left)
    }
    
    //边界发生变化时是否重新布局（视图滚动的时候也会触发）
    //会重新调用prepareLayout和调用
    //layoutAttributesForElementsInRect方法获得部分cell的布局属性
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    //rect范围下所有单元格位置属性
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
        //从父类得到默认的所有元素属性
        let array = super.layoutAttributesForElements(in: rect)
        
        //可见区域（目前显示出来的位于collection view上的矩形区域）
        let visiableRect = CGRect(x: self.collectionView!.contentOffset.x,
                                  y: self.collectionView!.contentOffset.y,
                                  width: self.collectionView!.frame.width,
                                  height: self.collectionView!.frame.height)
        
        //当前屏幕中点，相对于collect view上的x坐标
        let centerX = self.collectionView!.contentOffset.x
            + self.collectionView!.bounds.width / 2
        
        //这个是为了计算缩放比例的
        let maxDeviation = self.collectionView!.bounds.width / 2 + itemWidth / 2
        
        for attributes in array! {
            //与可见区域做碰撞，如果该单元格没显示则直接跳过
            if !visiableRect.intersects(attributes.frame) {continue}
            //显示的单元根据偏移量决定放大倍数（最大放大1.8倍，而离屏幕中央越远的单元格缩放的越小）
            let scale = 1 + (0.8 - abs(centerX - attributes.center.x) / maxDeviation)
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return array
    }
    
    /**
     用来设置collectionView停止滚动那一刻的位置(实现目的是当停止滑动，时刻有一张图片是位于屏幕最中央的)
     proposedContentOffset: 原本collectionView停止滚动那一刻的位置
     velocity:滚动速度
     返回：最终停留的位置
     */
    override func targetContentOffset(forProposedContentOffset
        proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        //停止滚动时的可见区域
        let lastRect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y,
                              width: self.collectionView!.bounds.width,
                              height: self.collectionView!.bounds.height)
        //当前屏幕中点，相对于collect view上的x坐标
        let centerX = proposedContentOffset.x + self.collectionView!.bounds.width * 0.5;
        //这个可见区域内所有的单元格属性
        let array = self.layoutAttributesForElements(in: lastRect)
        
        //需要移动的距离
        var adjustOffsetX = CGFloat(MAXFLOAT);
        for attri in array! {
            //每个单元格里中点的偏移量
            let deviation = attri.center.x - centerX
            //保存偏移最小的那个
            if abs(deviation) < abs(adjustOffsetX) {
                adjustOffsetX = deviation
            }
        }
        //通过偏移量返回最终停留的位置 
        return CGPoint(x: proposedContentOffset.x + adjustOffsetX, y: proposedContentOffset.y)
    }
}
