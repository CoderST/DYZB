//
//  STRowLayout.h
//  CollectionView
//
//  Created by xiudou on 2016/11/19.
//  Copyright © 2016年 STCode. All rights reserved.
//  仅支持高度固定,宽度不固定的布局

#import <UIKit/UIKit.h>
@class STRowLayout;
@protocol STRowLayoutDelegate <NSObject>

@required
// Variable height support
- (CGFloat)stLayout:(STRowLayout *)stLayout widthtForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
// Height of Item
- (CGFloat)heightForRowAtIndexPath:(STRowLayout *)stLayout;
// Space of Colums
- (CGFloat)layoutcolumnSpacingStLayout:(STRowLayout *)stLayout;
// Space of Row
- (CGFloat)layoutRowSpacingStLayout:(STRowLayout *)stLayout;
// TOP DOWN LEFT RIGHT
- (UIEdgeInsets)layoutEdgeInsetsStLayout:(STRowLayout *)stLayout;

@end
@interface STRowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<STRowLayoutDelegate> delegate;
@end
