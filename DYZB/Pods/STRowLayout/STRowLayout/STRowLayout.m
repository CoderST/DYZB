//
//  STRowLayout.m
//  CollectionView
//
//  Created by xiudou on 2016/11/19.
//  Copyright © 2016年 STCode. All rights reserved.

#import "STRowLayout.h"
// UIScreen Width
#define WINDOW_WIDTH [UIScreen mainScreen].bounds.size.width
// UIScreen Height
#define WINDOW_HEIGHT [UIScreen mainScreen].bounds.size.height

#pragma mark - 默认尺寸
/** item高度 */
static const CGFloat  stItemHeight = 100;
/** 列间距 */
static const CGFloat  stColumSpacing = 10;
/** 行间距 */
static const CGFloat  stRowSpacing = 10;
/** 边缘间距 */
static const UIEdgeInsets  stEdgeInsets = {10,10,10,10};

@interface STRowLayout()<UITableViewDelegate>

#pragma mark - 属性
/** atttibutesArray */
@property (nonatomic,strong) NSMutableArray *atttibutesArray;
/** 记录当前是第几行 */
@property (nonatomic,assign) NSInteger stCurrentRow;
/** 边缘间距 */
@property (nonatomic,assign) UIEdgeInsets stEdgeInsets;
/** 每一个item左边的的位置 */
@property (nonatomic,assign) CGFloat stItemLeft;
/** item高度 */
@property (nonatomic,assign) CGFloat stItemHeight;
/** 列间距 */
@property (nonatomic,assign) CGFloat stColumSpacing;
/** 行间距 */
@property (nonatomic,assign) CGFloat stRowSpacing;
@end
@implementation STRowLayout

#pragma mark - GET

- (CGFloat)stItemHeight{
    if ([self.delegate respondsToSelector:@selector(heightForRowAtIndexPath:) ]) {
        return [self.delegate heightForRowAtIndexPath:self];
    }else{
        
        return stItemHeight;
    }
}

// 列间距
- (CGFloat)stColumSpacing{
    if ([self.delegate respondsToSelector:@selector(layoutcolumnSpacingStLayout:)]) {
        return [self.delegate layoutcolumnSpacingStLayout:self];
    }else{
        
        return stColumSpacing;
    }
}

// 行间距
- (CGFloat)stRowSpacing{
    
    if ([self.delegate respondsToSelector:@selector(layoutRowSpacingStLayout:)]) {
        
        return [self.delegate layoutRowSpacingStLayout:self];
    }else{
        
        return stRowSpacing;
    }
}

// 边缘间距
- (UIEdgeInsets)stEdgeInsets{
    
    if ([self.delegate respondsToSelector:@selector(layoutEdgeInsetsStLayout:)]) {
        return [self.delegate layoutEdgeInsetsStLayout:self];
    }else{
        
        return stEdgeInsets;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)atttibutesArray{
    if (!_atttibutesArray) {
        _atttibutesArray = [NSMutableArray array];
    }
    return _atttibutesArray;
}
#pragma mark - 准备工作
- (void)prepareLayout{
    
    [super prepareLayout];
    
    self.stItemLeft = 0;
    self.stCurrentRow = 0;
    
    // 0 清除数据
    [self.atttibutesArray removeAllObjects];
    
    // 1 获取总共有多少item(一般情况下是一部分)
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int index = 0; index < count; index ++) {
        // 2 获取对象的indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        // 3 去除对应indexPath的LayoutAttributes对象
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        // 5 添加到数组
        [self.atttibutesArray addObject:attributes];
    }
    
    
}

// return an array layout attributes instances for all the views in the given rect
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.atttibutesArray;
    
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat width = [self.delegate stLayout:self widthtForRowAtIndexPath:indexPath];
    
    if (self.stEdgeInsets.left + self.stItemLeft + self.stColumSpacing + width + self.stEdgeInsets.right> WINDOW_WIDTH) {
        self.stItemLeft = self.stEdgeInsets.left;
        self.stCurrentRow ++;
    }else{
        self.stItemLeft = self.stItemLeft + self.stEdgeInsets.left + ( self.stColumSpacing);
    }
    
    CGFloat top = self.stEdgeInsets.top + self.stCurrentRow * (self.stItemHeight + self.stRowSpacing);
    // 处理第一行第一个item X的位置
    if (top == self.stEdgeInsets.top && self.stItemLeft == self.stEdgeInsets.left + self.stColumSpacing) {
        self.stItemLeft = self.stEdgeInsets.left;
    }
    attributes.frame = CGRectMake(self.stItemLeft, top, width, self.stItemHeight);
    // 记录itemLeft位置
    self.stItemLeft = self.stItemLeft + width;
    return attributes;
}


// Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling
- (CGSize)collectionViewContentSize{
    
    return CGSizeMake(0, self.stEdgeInsets.top + (self.stCurrentRow + 1 )* (self.stItemHeight + self.stRowSpacing) - self.stRowSpacing + self.stEdgeInsets.bottom);
}
@end

